from .extensions import db, bcrypt
from datetime import datetime, timezone
from sqlalchemy.dialects.postgresql import JSONB

__all__ = ['User', 'Campaign', 'Voter', 'Interaction', 'CampaignVoter']

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128))
    role = db.Column(db.String(80), nullable=False, default='user')

    def set_password(self, password):
        self.password_hash = bcrypt.generate_password_hash(password).decode('utf-8')

    def check_password(self, password):
        return bcrypt.check_password_hash(self.password_hash, password)

    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'role': self.role
        }

class Campaign(db.Model):
    __tablename__ = 'campaigns'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150), nullable=False)
    description = db.Column(db.Text, nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    user = db.relationship('User', backref=db.backref('campaigns', lazy=True))

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'user_id': self.user_id
        }

class Voter(db.Model):
    __tablename__ = 'voters'
    voter_id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(100), nullable=False)
    last_name = db.Column(db.String(100), nullable=False)
    email_address = db.Column(db.String(120), unique=True, nullable=True, index=True)
    phone_number = db.Column(db.String(20), unique=True, nullable=True)
    middle_name = db.Column(db.String(100), nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))
    source_campaign_id = db.Column(db.Integer, db.ForeignKey('campaigns.id'), nullable=True)
    custom_fields = db.Column(JSONB, nullable=True)

    def to_dict(self):
        return {
            'voter_id': self.voter_id,
            'first_name': self.first_name,
            'last_name': self.last_name,
            'email_address': self.email_address,
            'phone_number': self.phone_number,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        }

class Interaction(db.Model):
    __tablename__ = 'interactions'
    interaction_id = db.Column(db.Integer, primary_key=True)
    voter_id = db.Column(db.Integer, db.ForeignKey('voters.voter_id'), nullable=False)
    campaign_id = db.Column(db.Integer, db.ForeignKey('campaigns.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True) # Can be null for system-generated interactions
    interaction_type = db.Column(db.String(100), nullable=False) # e.g., 'Phone Call', 'Email', 'Door Knock', 'Website Signup'
    interaction_date = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))
    notes = db.Column(db.Text, nullable=True)
    outcome = db.Column(db.String(100), nullable=True) # e.g., 'Contacted', 'Left Voicemail', 'Not Interested'

class CampaignVoter(db.Model):
    __tablename__ = 'campaign_voters'
    campaign_id = db.Column(db.Integer, db.ForeignKey('campaigns.id'), primary_key=True)
    voter_id = db.Column(db.Integer, db.ForeignKey('voters.voter_id'), primary_key=True)
    # Add any additional fields specific to the relationship, e.g., support_level
    support_level = db.Column(db.String(50), nullable=True) # e.g., 'Strong Support', 'Undecided'