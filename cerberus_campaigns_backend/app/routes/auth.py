import jwt
from functools import wraps
from datetime import datetime, timedelta, timezone
from flask import Blueprint, request, jsonify, current_app
from ..models import User
from ..extensions import bcrypt

auth_bp = Blueprint('auth_bp', __name__, url_prefix='/auth')

def token_required(f):
    """Decorator to protect routes with JWT authentication."""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'Authorization' in request.headers:
            # Expected format: "Bearer <token>"
            token = request.headers['Authorization'].split(" ")[1]

        if not token:
            return jsonify({'message': 'Token is missing!'}), 401

        try:
            # Decode the token using the app's secret key
            data = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=["HS256"])
            current_user = User.query.filter_by(id=data['user_id']).first()
            if not current_user:
                return jsonify({'message': 'User not found!'}), 401
        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token has expired!'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'message': 'Token is invalid!'}), 401

        return f(current_user, *args, **kwargs)

    return decorated

@auth_bp.route('/login', methods=['POST'])
def login():
    """Authenticates a user and returns a JWT."""
    auth = request.get_json()

    if not auth or not auth.get('email') or not auth.get('password'):
        return jsonify({'message': 'Could not verify', 'error': 'Missing email or password'}), 401

    user = User.query.filter_by(email=auth.get('email')).first()

    if not user:
        return jsonify({'message': 'Could not verify', 'error': 'User not found'}), 401

    if bcrypt.check_password_hash(user.password_hash, auth.get('password')):
        # Generate the JWT
        token = jwt.encode({
            'user_id': user.id,
            'exp': datetime.now(timezone.utc) + timedelta(hours=24) # Token expires in 24 hours
        }, current_app.config['SECRET_KEY'], algorithm="HS256")

        return jsonify({
            'token': token,
            'user': user.to_dict()
        })

    return jsonify({'message': 'Could not verify', 'error': 'Invalid password'}), 401

@auth_bp.route('/verify', methods=['GET'])
@token_required
def verify_token(current_user):
    """An example protected route to verify a token."""
    if current_user:
        return jsonify({'message': 'Token is valid', 'user': current_user.to_dict()})
    return jsonify({'message': 'Token is invalid'}), 401