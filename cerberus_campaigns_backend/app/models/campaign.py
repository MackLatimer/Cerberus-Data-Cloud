from ..extensions import db
from .shared_mixins import TimestampMixin

class Campaign(TimestampMixin, db.Model):
    __tablename__ = 'campaigns'

    campaign_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    campaign_name = db.Column(db.String(255), nullable=False, unique=True)
    start_date = db.Column(db.Date, nullable=True)
    end_date = db.Column(db.Date, nullable=True)
    description = db.Column(db.Text, nullable=True)

    # Foreign key to the user who owns/manages this campaign
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'), nullable=False)
    user = db.relationship('User', backref=db.backref('campaigns', lazy='dynamic'))

    # Relationships
    # Voters associated with this campaign (through campaign_voters table)
    # campaign_voters is the association table model
    voters_association = db.relationship('CampaignVoter', back_populates='campaign', lazy='dynamic', cascade="all, delete-orphan")

    # Interactions associated with this campaign
    interactions = db.relationship('Interaction', back_populates='campaign', lazy='dynamic')

    # Survey questions specific to this campaign
    survey_questions = db.relationship('SurveyQuestion', back_populates='campaign', lazy='dynamic', cascade="all, delete-orphan")

    # Voters that were originally sourced by this campaign
    sourced_voters = db.relationship('Voter', back_populates='source_campaign', lazy='dynamic', foreign_keys='Voter.source_campaign_id')


    def __repr__(self):
        return f"<Campaign '{self.campaign_name}' (ID: {self.campaign_id})>"

    def to_dict(self):
        return {
            'campaign_id': self.campaign_id,
            'campaign_name': self.campaign_name,
            'start_date': self.start_date.isoformat() if self.start_date else None,
            'end_date': self.end_date.isoformat() if self.end_date else None,
            'description': self.description,
            'user_id': self.user_id,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
