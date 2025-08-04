from flask import Blueprint, request, jsonify, current_app
import stripe
from app.extensions import db
from app.models.donation import Donation

donate_bp = Blueprint('donate_bp', __name__, url_prefix='/api/v1/donate')

@donate_bp.route('/create-payment-intent', methods=['POST'])
def create_payment_intent():
    data = request.get_json()
    print(f"Received data: {data}")
    amount = data.get('amount')
    currency = data.get('currency', 'usd')

    if not amount:
        return jsonify({'error': 'Amount is required'}), 400

    try:
        stripe.api_key = current_app.config['STRIPE_SECRET_KEY']
        intent = stripe.PaymentIntent.create(
            amount=amount,
            currency=currency,
            metadata={'integration_check': 'accept_a_payment'},
        )

        donation_data = {
            'amount': amount / 100,
            'currency': currency,
            'stripe_payment_intent_id': intent.id,
            'payment_status': 'pending'
        }
        donation = Donation(**donation_data)
        
        print(f"Donation object before commit: {donation.__dict__}")

        db.session.add(donation)
        db.session.commit()

        return jsonify({
            'clientSecret': intent.client_secret,
            'paymentIntentId': intent.id
        })
    except stripe.error.StripeError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
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

    donation.first_name = data.get('first_name')
    donation.last_name = data.get('last_name')
    donation.address_line1 = data.get('address_line1')
    donation.address_line2 = data.get('address_line2')
    donation.address_city = data.get('address_city')
    donation.address_state = data.get('address_state')
    donation.address_zip = data.get('address_zip')
    donation.employer = data.get('employer')
    donation.occupation = data.get('occupation')
    donation.email = data.get('email')
    donation.phone_number = data.get('phone_number')
    donation.contact_email = data.get('contact_email')
    donation.contact_phone = data.get('contact_phone')
    donation.contact_mail = data.get('contact_mail')
    donation.contact_sms = data.get('contact_sms')

    db.session.commit()

    return jsonify({'message': 'Donation details updated successfully'})

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
        raise e
    except stripe.error.SignatureVerificationError as e:
        # Invalid signature
        raise e

    # Handle the event
    if event['type'] == 'payment_intent.succeeded':
        payment_intent = event['data']['object']
        donation = Donation.query.filter_by(stripe_payment_intent_id=payment_intent.id).first()
        if donation:
            donation.payment_status = 'succeeded'
            db.session.commit()

    return jsonify(success=True)