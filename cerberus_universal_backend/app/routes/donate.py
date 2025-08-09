from flask import Blueprint, request, jsonify, current_app
import stripe
from app.extensions import db
from app.models import Donation, Campaign, Person, PersonEmail, PersonPhone, DataSource
from sqlalchemy import text
from ..config import current_config
from ..utils.security import encrypt_data, decrypt_data

donate_bp = Blueprint('donate_bp', __name__, url_prefix='/api/v1/donate')

@donate_bp.route('/create-payment-intent', methods=['POST'])
def create_payment_intent():
    data = request.get_json()
    print(f"Received data: {data}")
    amount = data.get('amount')
    currency = data.get('currency', 'usd')
    campaign_id = data.get('campaign_id')
    person_id = data.get('person_id') # Optional
    email_str = data.get('email')
    phone_str = data.get('phone_number')

    if not amount:
        return jsonify({'error': 'Amount is required'}), 400
    if not campaign_id:
        return jsonify({'error': 'Campaign ID is required'}), 400

    campaign = db.session.get(Campaign, campaign_id)
    if not campaign:
        return jsonify({"error": f"Campaign with ID {campaign_id} not found."}), 404

    # Check if person_id is provided and valid
    if person_id:
        person = db.session.get(Person, person_id)
        if not person:
            return jsonify({"error": f"Person with ID {person_id} not found."}), 404

    try:
        print(f"Using Stripe Secret Key: {current_app.config['STRIPE_SECRET_KEY']}")
        stripe.api_key = current_app.config['STRIPE_SECRET_KEY']
        intent = stripe.PaymentIntent.create(
            amount=amount,
            currency=currency,
            automatic_payment_methods={'enabled': True},
        )

        # Encrypt sensitive data
        encrypted_email = encrypt_data(email_str)
        encrypted_phone = encrypt_data(phone_str)

        # Assuming a default data source with source_id = 1 exists
        default_source_id = 1

        donation_data = {
            'amount': amount / 100,
            'currency': currency,
            'stripe_payment_intent_id': intent.id,
            'payment_status': 'pending',
            'campaign_id': campaign_id,
            'person_id': person_id, # Will be None if not provided
            'first_name': data.get('first_name'),
            'last_name': data.get('last_name'),
            'address_line1': data.get('address_line1'),
            'address_line2': data.get('address_line2'),
            'address_city': data.get('address_city'),
            'address_state': data.get('address_state'),
            'address_zip': data.get('address_zip'),
            'employer': data.get('employer'),
            'occupation': data.get('occupation'),
            'email': encrypted_email,
            'phone_number': encrypted_phone,
            'contact_email': data.get('contact_email', False),
            'contact_phone': data.get('contact_phone', False),
            'contact_mail': data.get('contact_mail', False),
            'contact_sms': data.get('contact_sms', False),
            'is_recurring': data.get('is_recurring', False),
            'covers_fees': data.get('covers_fees', False),
            'source_id': default_source_id
        }
        donation = Donation(**donation_data)
        
        print(f"Donation object before commit: {donation.__dict__}")

        db.session.add(donation)
        db.session.commit()

        return jsonify({
            'clientSecret': intent.client_secret,
            'paymentIntentId': intent.id,
            'donationId': donation.id
        })
    except stripe.error.StripeError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        db.session.rollback()
        print(f"Exception during commit: {e}")
        return jsonify({'error': str(e)}), 500

@donate_bp.route('/update-donation-details', methods=['POST'])
def update_donation_details():
    data = request.get_json()
    payment_intent_id = data.get('payment_intent_id')

    if not payment_intent_id:
        return jsonify({'error': 'Payment Intent ID is required'}), 400

    donation = Donation.query.filter_by(stripe_payment_intent_id=payment_intent_id).first()

    if not donation:
        return jsonify({'error': 'Donation not found'}), 404

    # Update fields, encrypting sensitive ones
    donation.first_name = data.get('first_name', donation.first_name)
    donation.last_name = data.get('last_name', donation.last_name)
    donation.address_line1 = data.get('address_line1', donation.address_line1)
    donation.address_line2 = data.get('address_line2', donation.address_line2)
    donation.address_city = data.get('address_city', donation.address_city)
    donation.address_state = data.get('address_state', donation.address_state)
    donation.address_zip = data.get('address_zip', donation.address_zip)
    donation.employer = data.get('employer', donation.employer)
    donation.occupation = data.get('occupation', donation.occupation)
    
    if 'email' in data:
        donation.email = encrypt_data(data['email'])
    if 'phone_number' in data:
        donation.phone_number = encrypt_data(data['phone_number'])

    donation.contact_email = data.get('contact_email', donation.contact_email)
    donation.contact_phone = data.get('contact_phone', donation.contact_phone)
    donation.contact_mail = data.get('contact_mail', donation.contact_mail)
    donation.contact_sms = data.get('contact_sms', donation.contact_sms)
    donation.is_recurring = data.get('is_recurring', donation.is_recurring)
    donation.covers_fees = data.get('covers_fees', donation.covers_fees)
    donation.person_id = data.get('person_id', donation.person_id) # Allow updating person_id
    donation.campaign_id = data.get('campaign_id', donation.campaign_id) # Allow updating campaign_id

    try:
        db.session.commit()
        return jsonify({'message': 'Donation details updated successfully'}), 200
    except Exception as e:
        db.session.rollback()
        print(f"Error updating donation details: {e}")
        return jsonify({'error': str(e)}), 500

@donate_bp.route('/webhook', methods=['POST'])
def webhook():
    event = None
    payload = request.data
    sig_header = request.headers.get('stripe-signature')

    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, current_app.config['STRIPE_WEBHOOK_SECRET']
        )
    except ValueError as e:
        # Invalid payload
        return jsonify({'error': str(e)}), 400
    except stripe.error.SignatureVerificationError as e:
        # Invalid signature
        return jsonify({'error': str(e)}), 400

    # Handle the event
    if event['type'] == 'payment_intent.succeeded':
        payment_intent = event['data']['object']
        donation = Donation.query.filter_by(stripe_payment_intent_id=payment_intent.id).first()
        if donation:
            donation.payment_status = 'succeeded'
            try:
                db.session.commit()
            except Exception as e:
                print(f"Error committing webhook update: {e}")
                return jsonify({'error': str(e)}), 500

    return jsonify(success=True), 200
