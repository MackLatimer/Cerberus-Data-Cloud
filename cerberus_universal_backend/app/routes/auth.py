import datetime
import jwt
from flask import Blueprint, request, jsonify, current_app
from app.extensions import db, bcrypt
from app.models.user import User
from app.utils.security import token_required

auth_bp = Blueprint('auth_bp', __name__, url_prefix='/api/v1/auth')

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    if not data or not data.get('username') or not data.get('password'):
        return jsonify({'message': 'Username and password are required!'}), 400

    username = data['username']
    user_exists = User.query.filter_by(username=username).first()
    if user_exists:
        return jsonify({'message': 'Username already exists!'}), 409

    new_user = User(
        username=username,
        password=data['password'], # The model handles hashing via the constructor/setter
        email=data.get('email')
    )
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'New user created!'}), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    auth = request.authorization

    if not auth or not auth.username or not auth.password:
        # Fallback to JSON body if Basic Auth is not used
        data = request.get_json()
        if not data or not data.get('username') or not data.get('password'):
            return jsonify({'message': 'Could not verify'}), 401, {'WWW-Authenticate': 'Basic realm="Login required!"'}
        username = data.get('username')
        password = data.get('password')
    else:
        username = auth.username
        password = auth.password

    user = User.query.filter_by(username=username).first()

    if not user:
        return jsonify({'message': 'User not found!'}), 401

    if user.check_password(password):
            token = jwt.encode({
                'user_id': user.id,
                'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)
            }, current_app.config['FLASK_SECRET_KEY'], algorithm="HS256")
        return jsonify({'token': token})

    return jsonify({'message': 'Could not verify password!'}), 401

@auth_bp.route('/protected', methods=['GET'])
@token_required
def protected_route(current_user):
    """
    An example protected route to test the token decorator.
    """
    return jsonify({
        'message': 'This is a protected route.',
        'user': current_user.to_dict()
    })