from flask import current_app, request, jsonify
from sqlalchemy import text
from app.extensions import db
from app.models.user import User
from functools import wraps
import jwt
import hmac
import hashlib

def verify_webhook_signature(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        signature = request.headers.get('X-Webhook-Signature')
        if not signature:
            return jsonify({'message': 'Signature is missing!'}), 401

        # The secret key is loaded from environment variables.
        # In a production environment, this should be managed by a secret manager (e.g., Google Secret Manager).
        secret = current_app.config['WEBHOOK_SECRET_KEY']
        if not secret:
            # Log this error but don't expose details to the client
            current_app.logger.error("WEBHOOK_SECRET_KEY is not configured.")
            return jsonify({'message': 'Internal server error: webhook not configured'}), 500

        # It's crucial to use request.get_data() because it returns the raw request body.
        # request.data or request.get_json() might have already consumed or modified the body.
        request_body = request.get_data()

        expected_signature = hmac.new(
            key=secret.encode('utf-8'),
            msg=request_body,
            digestmod=hashlib.sha256
        ).hexdigest()

        if not hmac.compare_digest(expected_signature, signature):
            return jsonify({'message': 'Invalid signature.'}), 401

        return f(*args, **kwargs)
    return decorated_function

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'Authorization' in request.headers:
            # Expected format: "Bearer <token>"
            auth_header = request.headers['Authorization']
            parts = auth_header.split()
            if len(parts) == 2 and parts[0].lower() == 'bearer':
                token = parts[1]

        if not token:
            return jsonify({'message': 'Token is missing!'}), 401

        try:
            # Decode the token using the application's secret key
            data = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=["HS256"])
            current_user = db.session.get(User, data['user_id'])
            if not current_user:
                return jsonify({'message': 'User not found!'}), 401
        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token has expired!'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'message': 'Token is invalid!'}), 401

        # Pass the user object to the decorated function
        return f(current_user, *args, **kwargs)

    return decorated

def encrypt_data(data):
    """Encrypts data using pgp_sym_encrypt."""
    if data is None:
        return None
    # It's important to fetch the key from the current app context
    # to ensure it's the correct one for the active configuration.
    key = current_app.config.get('PGCRYPTO_SECRET_KEY')
    if not key:
        raise ValueError("PGCRYPTO_SECRET_KEY is not set in the application configuration.")
    return db.session.scalar(text("SELECT pgp_sym_encrypt(:data, :key)"), {'data': str(data), 'key': key})

def decrypt_data(data):
    """Decrypts data using pgp_sym_decrypt."""
    if data is None:
        return None
    key = current_app.config.get('PGCRYPTO_SECRET_KEY')
    if not key:
        raise ValueError("PGCRYPTO_SECRET_KEY is not set in the application configuration.")
    # The data from the DB is binary, so it doesn't need to be converted to string.
    return db.session.scalar(text("SELECT pgp_sym_decrypt(:data, :key)"), {'data': data, 'key': key})
