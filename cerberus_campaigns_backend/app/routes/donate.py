from flask import Blueprint, request, jsonify
import stripe
import os

stripe.api_key = os.environ.get('STRIPE_SECRET_KEY')

donate_bp = Blueprint('donate_bp', __name__)

@donate_bp.route('/api/v1/donate/create-checkout-session', methods=['POST'])
def create_checkout_session():
    data = request.get_json()
    amount = data['amount']

    try:
        session = stripe.checkout.Session.create(
            payment_method_types=['card', 'cashapp', 'us_bank_account'],
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
            success_url='https://emmons-194129.us-south1.run.app/donate?success=true',
            cancel_url='https://emmons-194129.us-south1.run.app/donate?success=false',
            billing_address_collection='required',
            shipping_address_collection={
                'allowed_countries': ['US'],
            },
            custom_fields=[
                {
                    'key': 'employer',
                    'label': {'type': 'custom', 'custom': 'Employer'},
                    'type': 'text',
                },
                {
                    'key': 'occupation',
                    'label': {'type': 'custom', 'custom': 'Occupation'},
                    'type': 'text',
                },
            ],
            payment_intent_data={
                'setup_future_usage': 'on_session',
            },
            allow_promotion_codes=False,
            submit_type='donate',
            metadata={
                'application_fee_amount': str(int(float(amount) * 100 * 0.03)),
            }
        )
        return jsonify({'sessionId': session.id})
    except Exception as e:
        return jsonify({'error': str(e)}), 400
