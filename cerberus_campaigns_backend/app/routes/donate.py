from flask import Blueprint, request, jsonify
import stripe
import os

stripe.api_key = os.environ.get('STRIPE_SECRET_KEY', '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')

donate_bp = Blueprint('donate_bp', __name__)

@donate_bp.route('/donate', methods=['POST'])
def create_payment_intent():
    data = request.get_json()
    amount = data['amount']

    try:
        payment_intent = stripe.PaymentIntent.create(
            amount=int(float(amount) * 100),
            currency='usd',
            payment_method_types=['card'],
            payment_method_options={
                "card": {
                    "installments": {"enabled": True}
                }
            },
        )
        return jsonify({'clientSecret': payment_intent.client_secret})
    except Exception as e:
        return jsonify({'error': str(e)}), 400
