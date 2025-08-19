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
    amount = data.get('amount')
    currency = data.get('currency', 'usd')
    campaign_id = data.get('campaign_id')

    if not amount:
        return jsonify({'error': 'Amount is required'}), 400
    if not campaign_id:
        return jsonify({'error': 'Campaign ID is required'}), 400

    campaign = db.session.get(Campaign, campaign_id)
    if not campaign:
        return jsonify({"error": f"Campaign with ID {campaign_id} not found."}), 404

    try:
        stripe_key_name = current_app.config['CAMPAIGN_STRIPE_KEY_MAPPING'].get(campaign_id)
        if not stripe_key_name:
            return jsonify({'error': 'Invalid campaign_id'}), 400

        stripe_secret_key = current_app.config['STRIPE_SECRET_KEYS'].get(stripe_key_name)
        if not stripe_secret_key:
            return jsonify({'error': 'Stripe secret key not found for campaign'}), 400

        stripe.api_key = stripe_secret_key
        intent = stripe.PaymentIntent.create(
            amount=amount,
            currency=currency,
            automatic_payment_methods={'enabled': True},
        )

        return jsonify({
            'clientSecret': intent.client_secret,
        })
    except stripe.error.StripeError as e:
        current_app.logger.error(f"Stripe error while creating PaymentIntent: {e}")
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        current_app.logger.error(f"Unexpected error while creating PaymentIntent: {e}")
        return jsonify({'error': str(e)}), 500

@donate_bp.route('/record-donation', methods=['POST'])
def record_donation():
    data = request.get_json()
    payment_intent_id = data.get('payment_intent_id')

    if not payment_intent_id:
        return jsonify({'error': 'Payment Intent ID is required'}), 400

    # Check if a donation with this payment intent already exists
    existing_donation = Donation.query.filter_by(stripe_payment_intent_id=payment_intent_id).first()
    if existing_donation:
        return jsonify({'message': 'Donation already recorded'}), 200

    # Encrypt sensitive data
    encrypted_email = encrypt_data(data.get('email'))
    encrypted_phone = encrypt_data(data.get('phone_number'))

    # Assuming a default data source with source_id = 1 exists
    default_source_id = 1

    donation_data = {
        'amount': data.get('amount') / 100,
        'currency': data.get('currency', 'usd'),
        'stripe_payment_intent_id': payment_intent_id,
        'payment_status': 'succeeded',
        'campaign_id': data.get('campaign_id'),
        'person_id': data.get('person_id'), # Will be None if not provided
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

    try:
        db.session.add(donation)
        db.session.commit()
        return jsonify({'message': 'Donation recorded successfully', 'donationId': donation.id}), 201
    except Exception as e:
        db.session.rollback()
        print(f"Exception during commit: {e}")
        return jsonify({'error': str(e)}), 500

@donate_bp.route('/webhook/<campaign_id>', methods=['POST'])
def webhook(campaign_id):
    event = None
    payload = request.data
    sig_header = request.headers.get('stripe-signature')

    try:
        stripe_key_name = current_app.config['CAMPAIGN_STRIPE_KEY_MAPPING'].get(int(campaign_id))
        if not stripe_key_name:
            return jsonify({'error': 'Invalid campaign_id'}), 400

        webhook_secret = current_app.config['STRIPE_WEBHOOK_SECRETS'].get(stripe_key_name)
        if not webhook_secret:
            return jsonify({'error': 'Stripe webhook secret not found for campaign'}), 400

        event = stripe.Webhook.construct_event(
            payload, sig_header, webhook_secret
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