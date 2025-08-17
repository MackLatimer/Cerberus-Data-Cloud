
import stripe
import os
from flask import Blueprint, request, jsonify

# This is a conceptual example. In a real app, you would use a more robust way
# to handle database operations and configuration.
from ..models import Donation, db

webhooks_bp = Blueprint('webhooks', __name__)

# It is critical to fetch these from a secure location, not hardcode them.
# The original default_config.json correctly references Google Secret Manager.
STRIPE_API_KEY = os.environ.get('STRIPE_SECRET_KEY')
STRIPE_WEBHOOK_SECRET = os.environ.get('STRIPE_WEBHOOK_SECRET')

stripe.api_key = STRIPE_API_KEY

@webhooks_bp.route('/stripe', methods=['POST'])
def stripe_webhook():
    """
    Listens for and processes webhooks from Stripe.

    This endpoint is the source of truth for payment status. It handles events
    asynchronously from the user's donation flow.
    """
    if not STRIPE_WEBHOOK_SECRET:
        print("ERROR: Stripe webhook secret is not configured.")
        return jsonify(error="Webhook secret not configured"), 500

    payload = request.data
    sig_header = request.headers.get('Stripe-Signature')
    event = None

    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, STRIPE_WEBHOOK_SECRET
        )
    except ValueError as e:
        # Invalid payload
        print(f"ERROR: Invalid webhook payload. {e}")
        return jsonify(error="Invalid payload"), 400
    except stripe.error.SignatureVerificationError as e:
        # Invalid signature
        print(f"ERROR: Invalid webhook signature. {e}")
        return jsonify(error="Invalid signature"), 400

    # Handle the event
    if event['type'] == 'payment_intent.succeeded':
        payment_intent = event['data']['object']
        payment_intent_id = payment_intent['id']
        
        print(f"SUCCESS: PaymentIntent {payment_intent_id} succeeded.")
        
        # --- Business Logic ---
        # This is where you make your database consistent with the payment.
        # 1. Find the donation record using the payment_intent_id.
        #    The frontend should have already created a preliminary record.
        # 2. Mark the donation as 'completed' or 'successful'.
        # 3. Trigger other actions like sending a confirmation email,
        #    updating donor records, etc.
        
        # Example database interaction (conceptual):
        # donation = Donation.query.filter_by(payment_intent_id=payment_intent_id).first()
        # if donation:
        #     donation.status = 'succeeded'
        #     # Potentially save more details from the payment_intent object
        #     donation.amount_received = payment_intent['amount_received']
        #     db.session.commit()
        #     # send_thank_you_email(donation.donor_email)
        # else:
        #     # This case is unlikely if the frontend is working correctly but
        #     # should be logged for investigation.
        #     print(f"WARNING: Received webhook for unknown PaymentIntent: {payment_intent_id}")

    elif event['type'] == 'payment_intent.payment_failed':
        payment_intent = event['data']['object']
        payment_intent_id = payment_intent['id']
        error_message = payment_intent['last_payment_error']['message'] if payment_intent.get('last_payment_error') else 'No message'
        
        print(f"INFO: PaymentIntent {payment_intent_id} failed. Reason: {error_message}")
        
        # --- Business Logic for Failure ---
        # 1. Find the donation record.
        # 2. Mark it as 'failed'.
        # 3. Optionally, trigger an email to the user or an internal alert.
        
        # Example (conceptual):
        # donation = Donation.query.filter_by(payment_intent_id=payment_intent_id).first()
        # if donation:
        #     donation.status = 'failed'
        #     db.session.commit()

    else:
        print(f"Unhandled event type {event['type']}")

    return jsonify(status="success"), 200

