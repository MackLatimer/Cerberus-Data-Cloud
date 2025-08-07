from ..extensions import db
from .shared_mixins import TimestampMixin

class Interaction(db.Model):
    __tablename__ = 'interactions'

    interaction_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    voter_id = db.Column(db.Integer, db.ForeignKey('voters.voter_id', ondelete='CASCADE'), nullable=False, index=True)
    campaign_id = db.Column(db.Integer, db.ForeignKey('campaigns.campaign_id', ondelete='SET NULL'), nullable=True, index=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id', ondelete='SET NULL'), nullable=True)

    interaction_type = db.Column(db.String(100), nullable=False, index=True)
    interaction_date = db.Column(db.DateTime(timezone=True), nullable=False, server_default=db.func.now())
    outcome = db.Column(db.String(255), nullable=True)
    notes = db.Column(db.Text, nullable=True)
    duration_minutes = db.Column(db.Integer, nullable=True)

    created_at = db.Column(db.DateTime(timezone=True), server_default=db.func.now())

    voter = db.relationship('Voter', back_populates='interactions')
    campaign = db.relationship('Campaign', back_populates='interactions')
    user = db.relationship('User', back_populates='interactions')

    survey_responses = db.relationship('SurveyResult', back_populates='interaction', lazy='dynamic', cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Interaction ID: {self.interaction_id} (Voter: {self.voter_id}, Type: {self.interaction_type})>"

    def to_dict(self):
        return {
            'interaction_id': self.interaction_id,
            'voter_id': self.voter_id,
            'campaign_id': self.campaign_id,
            'user_id': self.user_id,
            'interaction_type': self.interaction_type,
            'interaction_date': self.interaction_date.isoformat() if self.interaction_date else None,
            'outcome': self.outcome,
            'notes': self.notes,
            'duration_minutes': self.duration_minutes,
            'created_at': self.created_at.isoformat() if self.created_at else None,
        }
