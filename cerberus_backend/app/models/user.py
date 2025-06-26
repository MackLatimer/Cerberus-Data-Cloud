from ..extensions import db, bcrypt
from .shared_mixins import TimestampMixin
# If using JWTs for auth tokens, you might import related libraries here or in a service layer
# import jwt
# import datetime
# from flask import current_app

class User(TimestampMixin, db.Model):
    __tablename__ = 'users'

    user_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(100), nullable=False, unique=True, index=True)
    password_hash = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=True, index=True) # Email can be optional or mandatory based on needs
    first_name = db.Column(db.String(100), nullable=True)
    last_name = db.Column(db.String(100), nullable=True)
    role = db.Column(db.String(50), default='viewer', nullable=False) # e.g., 'admin', 'editor', 'viewer'
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    last_login = db.Column(db.DateTime(timezone=True), nullable=True)

    # Relationships
    # Interactions logged by this user
    interactions = db.relationship('Interaction', back_populates='user', lazy='dynamic')

    def __init__(self, username, password, email=None, first_name=None, last_name=None, role='viewer', is_active=True):
        self.username = username
        self.set_password(password)
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.role = role
        self.is_active = is_active

    def set_password(self, password):
        self.password_hash = bcrypt.generate_password_hash(password).decode('utf-8')

    def check_password(self, password):
        return bcrypt.check_password_hash(self.password_hash, password)

    @property
    def full_name(self):
        if self.first_name and self.last_name:
            return f"{self.first_name} {self.last_name}"
        elif self.first_name:
            return self.first_name
        elif self.last_name:
            return self.last_name
        return self.username

    def __repr__(self):
        return f"<User '{self.username}' (Role: {self.role})>"

    def to_dict(self, include_sensitive=False):
        data = {
            'user_id': self.user_id,
            'username': self.username,
            'email': self.email,
            'first_name': self.first_name,
            'last_name': self.last_name,
            'full_name': self.full_name,
            'role': self.role,
            'is_active': self.is_active,
            'last_login': self.last_login.isoformat() if self.last_login else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
        # Never include password_hash by default
        return data

    # Example methods for JWT token generation (if implementing token-based auth)
    # def encode_auth_token(self, token_type='access'):
    #     """
    #     Generates the Auth Token
    #     :return: string
    #     """
    #     try:
    #         if token_type == 'access':
    #             expires_delta = datetime.timedelta(minutes=current_app.config.get('ACCESS_TOKEN_EXPIRE_MINUTES', 30))
    #         elif token_type == 'refresh':
    #             expires_delta = datetime.timedelta(days=current_app.config.get('REFRESH_TOKEN_EXPIRE_DAYS', 7))
    #         else:
    #             raise ValueError("Invalid token type")

    #         payload = {
    #             'exp': datetime.datetime.utcnow() + expires_delta,
    #             'iat': datetime.datetime.utcnow(),
    #             'sub': self.user_id, # Subject of the token is the user ID
    #             'type': token_type,
    #             'role': self.role # Optionally include role or other non-sensitive claims
    #         }
    #         return jwt.encode(
    #             payload,
    #             current_app.config.get('JWT_SECRET_KEY'),
    #             algorithm=current_app.config.get('JWT_ALGORITHM', 'HS256')
    #         )
    #     except Exception as e:
    #         return e

    # @staticmethod
    # def decode_auth_token(auth_token):
    #     """
    #     Decodes the auth token
    #     :param auth_token:
    #     :return: integer|string
    #     """
    #     try:
    #         payload = jwt.decode(auth_token, current_app.config.get('JWT_SECRET_KEY'), algorithms=[current_app.config.get('JWT_ALGORITHM', 'HS256')])
    #         return payload # Contains 'sub' (user_id), 'type', 'role', 'exp', 'iat'
    #     except jwt.ExpiredSignatureError:
    #         return 'Signature expired. Please log in again.'
    #     except jwt.InvalidTokenError:
    #         return 'Invalid token. Please log in again.'
