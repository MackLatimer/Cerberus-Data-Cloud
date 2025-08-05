from ..extensions import db
from .shared_mixins import TimestampMixin

class Campaign(TimestampMixin, db.Model):
    __tablename__ = 'campaigns'

    campaign_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    campaign_name = db.Column(db.String(255), nullable=False, unique=True)
    start_date = db.Column(db.Date, nullable=True)
    end_date = db.Column(db.Date, nullable=True)
    description = db.Column(db.Text, nullable=True)

    voters_association = db.relationship('CampaignVoter', back_populates='campaign', lazy='dynamic', cascade="all, delete-orphan")

    interactions = db.relationship('Interaction', back_populates='campaign', lazy='dynamic')

    survey_questions = db.relationship('SurveyQuestion', back_populates='campaign', lazy='dynamic', cascade="all, delete-orphan")

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
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
