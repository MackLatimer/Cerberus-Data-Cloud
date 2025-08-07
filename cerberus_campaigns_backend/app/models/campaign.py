from ..extensions import db

class Campaign(db.Model):
    __tablename__ = 'campaigns'

    campaign_id = db.Column(db.Integer, primary_key=True)
    campaign_name = db.Column(db.String(255))
    start_date = db.Column(db.Date)
    end_date = db.Column(db.Date)
    campaign_type = db.Column(db.Enum('Local', 'State', 'Federal', 'Issue', name='campaign_type_enum'))
    details = db.Column(db.JSON)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id', use_alter=True))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    sourced_voters = db.relationship('Voter', back_populates='source_campaign', foreign_keys='Voter.source_campaign_id')
    voters_association = db.relationship('CampaignVoter', back_populates='campaign')
    interactions = db.relationship('Interaction', back_populates='campaign')

    def to_dict(self):
        return {
            'campaign_id': self.campaign_id,
            'campaign_name': self.campaign_name,
            'start_date': self.start_date.isoformat() if self.start_date else None,
            'end_date': self.end_date.isoformat() if self.end_date else None,
            'campaign_type': self.campaign_type,
            'details': self.details,
            'source_id': self.source_id,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
