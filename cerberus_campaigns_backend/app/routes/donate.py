from flask import Blueprint, request, jsonify
import stripe

donate_bp = Blueprint('donate_bp', __name__)

@donate_bp.route('/api/v1/donate/create-checkout-session', methods=['POST'])
def create_checkout_session():
    data = request.get_json()
    amount = data['amount']

    try:
        session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[{
                'price_data': {
                    'currency': 'usd',
                    'product_data': {
                        'name': 'Donation',
                    },
                    'unit_amount': int(float(amount) * 100),
                },
                'quantity': 1,
            }],
            mode='payment',
            success_url='https://emmons-194129.us-south1.run.app/donate/success',
            cancel_url='https://emmons-194129.us-south1.run.app/donate/cancel',
        )
        return jsonify({'sessionId': session.id})
    except Exception as e:
        return jsonify({'error': str(e)}), 400
