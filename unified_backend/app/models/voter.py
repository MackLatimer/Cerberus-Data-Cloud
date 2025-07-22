from ..extensions import db
from .shared_mixins import TimestampMixin

class Voter(TimestampMixin, db.Model):
    __tablename__ = 'voters'

    voter_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    first_name = db.Column(db.String(100), nullable=False)
    middle_name = db.Column(db.String(100), nullable=True)
    last_name = db.Column(db.String(100), nullable=False, index=True)
    date_of_birth = db.Column(db.Date, nullable=True)
    gender = db.Column(db.String(50), nullable=True)

    # Address Information
    street_address = db.Column(db.String(255), nullable=True)
    city = db.Column(db.String(100), nullable=True)
    state = db.Column(db.String(50), nullable=True)
    zip_code = db.Column(db.String(20), nullable=True, index=True)
    county = db.Column(db.String(100), nullable=True)
    precinct = db.Column(db.String(100), nullable=True)

    # Contact Information
    phone_number = db.Column(db.String(20), unique=True, nullable=True, index=True)
    email_address = db.Column(db.String(255), unique=True, nullable=True, index=True)

    # Voter Registration Information
    registration_status = db.Column(db.String(50), nullable=True)
    voter_registration_id = db.Column(db.String(100), unique=True, nullable=True, index=True)
    registration_date = db.Column(db.Date, nullable=True)
    party_affiliation = db.Column(db.String(100), nullable=True)

    # Engagement Metrics
    engagement_score = db.Column(db.Integer, default=0)
    last_contacted_date = db.Column(db.DateTime(timezone=True), nullable=True)
    preferred_contact_method = db.Column(db.String(50), nullable=True)

    # Custom Fields
    custom_fields = db.Column(db.JSON, nullable=True)

    # Foreign Key for source campaign
    source_campaign_id = db.Column(db.Integer, db.ForeignKey('campaigns.campaign_id'), nullable=True)
    source_campaign = db.relationship('Campaign', back_populates='sourced_voters', foreign_keys=[source_campaign_id])

    # Relationships
    # Campaigns this voter is associated with (through campaign_voters table)
    campaigns_association = db.relationship('CampaignVoter', back_populates='voter', lazy='dynamic', cascade="all, delete-orphan")

    # Interactions with this voter
    interactions = db.relationship('Interaction', back_populates='voter', lazy='dynamic', cascade="all, delete-orphan")

    # Survey responses by this voter
    survey_responses = db.relationship('SurveyResponse', back_populates='voter', lazy='dynamic', cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Voter '{self.first_name} {self.last_name}' (ID: {self.voter_id})>"

    def to_dict(self):
        return {
            'voter_id': self.voter_id,
            'first_name': self.first_name,
            'middle_name': self.middle_name,
            'last_name': self.last_name,
            'date_of_birth': self.date_of_birth.isoformat() if self.date_of_birth else None,
            'gender': self.gender,
            'street_address': self.street_address,
            'city': self.city,
            'state': self.state,
            'zip_code': self.zip_code,
            'county': self.county,
            'precinct': self.precinct,
            'phone_number': self.phone_number,
            'email_address': self.email_address,
            'registration_status': self.registration_status,
            'voter_registration_id': self.voter_registration_id,
            'registration_date': self.registration_date.isoformat() if self.registration_date else None,
            'party_affiliation': self.party_affiliation,
            'engagement_score': self.engagement_score,
            'last_contacted_date': self.last_contacted_date.isoformat() if self.last_contacted_date else None,
            'preferred_contact_method': self.preferred_contact_method,
            'custom_fields': self.custom_fields,
            'source_campaign_id': self.source_campaign_id,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }

class CampaignVoter(db.Model):
    __tablename__ = 'campaign_voters'
    # Using TimestampMixin here is optional, depends if you need to track when association was made/updated
    # For simplicity, schema.sql adds `added_at` with a default. If `updated_at` is needed, add TimestampMixin.

    campaign_voter_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    campaign_id = db.Column(db.Integer, db.ForeignKey('campaigns.campaign_id', ondelete='CASCADE'), nullable=False)
    voter_id = db.Column(db.Integer, db.ForeignKey('voters.voter_id', ondelete='CASCADE'), nullable=False)
    added_at = db.Column(db.DateTime(timezone=True), server_default=db.func.now())

    # Relationships to parent tables
    campaign = db.relationship('Campaign', back_populates='voters_association')
    voter = db.relationship('Voter', back_populates='campaigns_association')

    # Unique constraint to ensure a voter is only added once per campaign
    __table_args__ = (db.UniqueConstraint('campaign_id', 'voter_id', name='uq_campaign_voter'),)

    def __repr__(self):
        return f"<CampaignVoter (Campaign: {self.campaign_id}, Voter: {self.voter_id})>"

    def to_dict(self):
        return {
            'campaign_voter_id': self.campaign_voter_id,
            'campaign_id': self.campaign_id,
            'voter_id': self.voter_id,
            'added_at': self.added_at.isoformat() if self.added_at else None
        }
