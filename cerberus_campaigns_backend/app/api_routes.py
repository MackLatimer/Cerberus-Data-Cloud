import stripe
import os
from flask import Blueprint, request, jsonify

# Create a Blueprint to organize routes
api_bp = Blueprint('api_bp', __name__)

# --- Crucial Security Step ---
# Initialize Stripe with the secret key from your environment variables.
# This key should be set in your Cloud Run service configuration, NOT in the code.
stripe.api_key = os.environ.get('STRIPE_SECRET_KEY')

@api_bp.route('/create-payment-intent', methods=['POST'])
def create_payment():
    # Check if the Stripe key is configured on the server
    if not stripe.api_key:
        return jsonify(error={'message': 'Stripe API key is not configured on the server.'}), 500

    try:
        data = request.get_json()
        if not data or 'amount' not in data or 'currency' not in data:
            return jsonify(error={'message': 'Missing amount or currency in request body.'}), 400

        # Create a PaymentIntent with the order amount and currency
        intent = stripe.PaymentIntent.create(
            amount=data['amount'],
            currency=data['currency'],
            automatic_payment_methods={'enabled': True},
        )
        # Return the client_secret to the frontend
        return jsonify({'clientSecret': intent.client_secret})
    except Exception as e:
        print(f"Error creating PaymentIntent: {e}") # Log error for debugging
        return jsonify(error={'message': str(e)}), 500