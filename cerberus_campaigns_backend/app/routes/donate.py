from flask import Blueprint, request, jsonify, current_app
import stripe
import os
import json
from app.models.donation import Donation
from app.models.voter import Voter
from app.extensions import db

donate_bp = Blueprint('donate_bp', __name__, url_prefix='/api/v1')

# Helper function to calculate amount with fees
def calculate_amount_with_fees(original_amount):
    # Stripe fees: 2.9% + 30 cents for US cards
    # To cover fees, the formula is: (amount + 0.30) / (1 - 0.029)
    # All amounts are in cents for Stripe
    amount_in_cents = int(float(original_amount) * 100)
    amount_with_fees_in_cents = int((amount_in_cents + 30) / (1 - 0.029))
    return amount_with_fees_in_cents

@donate_bp.route('/create-payment-intent', methods=['POST'])
def create_payment_intent():
    data = request.get_json()
    amount = data.get('amount')
    currency = data.get('currency', 'usd')
    is_recurring = data.get('is_recurring', False)
    covers_fees = data.get('covers_fees', False)
    donor_email = data.get('email') # Email for customer creation

    if not amount:
        return jsonify({'error': 'Amount is required'}), 400

    try:
        stripe.api_key = current_app.config['STRIPE_SECRET_KEY']

        final_amount_in_cents = int(float(amount) * 100)
        if covers_fees:
            final_amount_in_cents = calculate_amount_with_fees(amount)

        customer_id = None
        if is_recurring:
            # Create a Stripe Customer for recurring donations
            customer = stripe.Customer.create(
                email=donor_email,
                description=f"Customer for recurring donation of {amount} {currency}",
            )
            customer_id = customer.id

        # Create a Payment Intent
        intent = stripe.PaymentIntent.create(
            amount=final_amount_in_cents,
            currency=currency,
            customer=customer_id, # Attach customer if recurring
            setup_future_usage='off_session' if is_recurring else None, # For recurring payments
            metadata={
                'original_amount': amount,
                'is_recurring': is_recurring,
                'covers_fees': covers_fees,
                'email': donor_email # Store email in metadata for easy access
            }
        )
        return jsonify({
            'clientSecret': intent.client_secret,
            'paymentIntentId': intent.id,
            'customerId': customer_id
        })
    except stripe.error.StripeError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@donate_bp.route('/confirm-payment-intent', methods=['POST'])
def confirm_payment_intent():
    data = request.get_json()
    payment_intent_id = data.get('paymentIntentId')
    payment_method_id = data.get('paymentMethodId') # From frontend after card details are entered

    if not payment_intent_id or not payment_method_id:
        return jsonify({'error': 'Payment Intent ID and Payment Method ID are required'}), 400

    try:
        stripe.api_key = current_app.config['STRIPE_SECRET_KEY']
        intent = stripe.PaymentIntent.confirm(
            payment_intent_id,
            payment_method=payment_method_id
        )
        return jsonify({
            'status': intent.status,
            'paymentIntentId': intent.id
        })
    except stripe.error.CardError as e:
        # Display error to the user (e.g., insufficient funds)
        return jsonify({'error': e.user_message}), 400
    except stripe.error.StripeError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@donate_bp.route('/stripe-webhook', methods=['POST'])
def stripe_webhook():
    payload = request.get_data()
    sig_header = request.headers.get('stripe-signature')
    event = None

    try:
        stripe.api_key = current_app.config['STRIPE_SECRET_KEY']
        webhook_secret = current_app.config.get('STRIPE_WEBHOOK_SECRET') # Get from config

        if webhook_secret:
            event = stripe.Webhook.construct_event(
                payload, sig_header, webhook_secret
            )
        else:
            # For local testing without webhook secret (NOT FOR PRODUCTION)
            event = stripe.Event.construct_from(
                json.loads(payload), stripe.api_key
            )
    except ValueError as e:
        # Invalid payload
        current_app.logger.error(f"Webhook Error: Invalid payload: {e}")
        return jsonify({'error': 'Invalid payload'}), 400
    except stripe.error.SignatureVerificationError as e:
        # Invalid signature
        current_app.logger.error(f"Webhook Error: Invalid signature: {e}")
        return jsonify({'error': 'Invalid signature'}), 400
    except Exception as e:
        current_app.logger.error(f"Webhook Error: {e}")
        return jsonify({'error': str(e)}), 400

    # Handle the event
    if event['type'] == 'payment_intent.succeeded':
        payment_intent = event['data']['object']
        current_app.logger.info(f"PaymentIntent Succeeded: {payment_intent.id}")

        # Retrieve metadata
        original_amount = payment_intent.metadata.get('original_amount')
        is_recurring = payment_intent.metadata.get('is_recurring', 'False').lower() == 'true'
        covers_fees = payment_intent.metadata.get('covers_fees', 'False').lower() == 'true'
        donor_email = payment_intent.metadata.get('email')

        # Check if a donation record already exists for this payment intent
        donation = Donation.query.filter_by(stripe_payment_intent_id=payment_intent.id).first()

        if not donation:
            # Create a new Donation record
            new_donation = Donation(
                stripe_payment_intent_id=payment_intent.id,
                stripe_customer_id=payment_intent.customer,
                amount=float(original_amount),
                currency=payment_intent.currency,
                payment_status='succeeded',
                is_recurring=is_recurring,
                covers_fees=covers_fees,
                email=donor_email # Store initial email from PI metadata
            )
            db.session.add(new_donation)
            db.session.commit()
            current_app.logger.info(f"New Donation record created: {new_donation.id}")
        else:
            # Update existing donation record if it was created earlier (e.g., by a setup_intent)
            donation.payment_status = 'succeeded'
            db.session.commit()
            current_app.logger.info(f"Existing Donation record updated to succeeded: {donation.id}")

        # If recurring, a subscription will be created separately or needs to be handled
        # if the PaymentIntent was part of a subscription creation flow.
        # For now, we assume the subscription is created via the frontend or a separate flow.

    elif event['type'] == 'customer.subscription.created' or event['type'] == 'customer.subscription.updated':
        subscription = event['data']['object']
        current_app.logger.info(f"Subscription {event['type']}: {subscription.id}")

        # Find the related donation or create a new one if this is the first payment
        # This assumes a link between subscription and initial donation/customer
        donation = Donation.query.filter_by(stripe_customer_id=subscription.customer, is_recurring=True).first()

        if donation:
            donation.stripe_subscription_id = subscription.id
            donation.payment_status = subscription.status # e.g., 'active', 'trialing'
            db.session.commit()
            current_app.logger.info(f"Donation {donation.id} updated with subscription ID: {subscription.id}")
        else:
            # This case might happen if the subscription is created without a prior PaymentIntent
            # or if the initial donation was not marked as recurring.
            # You might want to create a new Donation record here for the subscription.
            current_app.logger.warning(f"No existing donation found for subscription {subscription.id} and customer {subscription.customer}")

    elif event['type'] == 'payment_method.attached':
        payment_method = event['data']['object']
        current_app.logger.info(f"PaymentMethod Attached: {payment_method.id} to customer {payment_method.customer}")
        # You might want to update a customer's default payment method or store this info.

    elif event['type'] == 'checkout.session.completed':
        # This is for backward compatibility if you still use Checkout Sessions
        session = event['data']['object']
        current_app.logger.info(f"Checkout Session Completed (Legacy): {session.id}")
        # You might still want to process these if old links are active
        # For new flow, this should not be the primary event.

    elif event['type'] == 'payment_intent.payment_failed':
        payment_intent = event['data']['object']
        current_app.logger.warning(f"PaymentIntent Failed: {payment_intent.id}")
        donation = Donation.query.filter_by(stripe_payment_intent_id=payment_intent.id).first()
        if donation:
            donation.payment_status = 'failed'
            db.session.commit()
            current_app.logger.info(f"Donation {donation.id} marked as failed.")

    else:
        current_app.logger.info(f'Unhandled event type {event["type"]}')

    return jsonify({'status': 'success'})

@donate_bp.route('/update-donation-details', methods=['POST'])
def update_donation_details():
    data = request.get_json()
    # Now using payment_intent_id to link to the donation
    payment_intent_id = data.get('payment_intent_id')
    if not payment_intent_id:
        return jsonify({'error': 'Payment Intent ID is required'}), 400

    donation = Donation.query.filter_by(stripe_payment_intent_id=payment_intent_id).first()

    if not donation:
        return jsonify({'error': 'Donation record not found for this Payment Intent ID'}), 404

    try:
        # Update donor information
        donation.first_name = data.get('first_name')
        donation.last_name = data.get('last_name')
        donation.address_line1 = data.get('address_line1')
        donation.address_line2 = data.get('address_line2')
        donation.address_city = data.get('address_city')
        donation.address_state = data.get('address_state')
        donation.address_zip = data.get('address_zip')
        donation.employer = data.get('employer')
        donation.occupation = data.get('occupation')
        # Email and phone number might be updated here if not provided initially
        donation.email = data.get('email', donation.email)
        donation.phone_number = data.get('phone_number', donation.phone_number)

        # Contact preferences (checkboxes)
        donation.contact_email = data.get('contact_email', donation.contact_email)
        donation.contact_phone = data.get('contact_phone', donation.contact_phone)
        donation.contact_mail = data.get('contact_mail', donation.contact_mail)
        donation.contact_sms = data.get('contact_sms', donation.contact_sms)

        db.session.commit()

        # Optionally, update or create a Voter record
        # This logic assumes you want to link donations to voters
        voter = Voter.query.filter_by(email_address=donation.email).first()
        if not voter:
            voter = Voter(
                first_name=donation.first_name,
                last_name=donation.last_name,
                email_address=donation.email,
                phone_number=donation.phone_number,
                street_address=donation.address_line1,
                city=donation.address_city,
                state=donation.address_state,
                zip_code=donation.address_zip,
                contact_email=donation.contact_email,
                contact_phone=donation.contact_phone,
                contact_mail=donation.contact_mail,
                contact_sms=donation.contact_sms,
                # You might want to add more fields from donation to voter
            )
            db.session.add(voter)
        else:
            # Update existing voter with latest info
            voter.first_name = donation.first_name
            voter.last_name = donation.last_name
            voter.phone_number = donation.phone_number
            voter.street_address = donation.address_line1
            voter.city = donation.address_city
            voter.state = donation.address_state
            voter.zip_code = donation.address_zip
            voter.contact_email = donation.contact_email
            voter.contact_phone = donation.contact_phone
            voter.contact_mail = donation.contact_mail
            voter.contact_sms = donation.contact_sms
        db.session.commit()

        return jsonify({'message': 'Donation and Voter details updated successfully'}), 200
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error updating donation details: {e}")
        return jsonify({'error': str(e)}), 500