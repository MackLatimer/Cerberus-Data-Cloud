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

    street_address = db.Column(db.String(255), nullable=True)
    city = db.Column(db.String(100), nullable=True)
    state = db.Column(db.String(50), nullable=True)
    zip_code = db.Column(db.String(20), nullable=True, index=True)
    county = db.Column(db.String(100), nullable=True)
    precinct = db.Column(db.String(100), nullable=True)

    phone_number = db.Column(db.String(20), unique=True, nullable=True, index=True)
    email_address = db.Column(db.String(255), unique=True, nullable=True, index=True)

    employer = db.Column(db.String(255), nullable=True)
    occupation = db.Column(db.String(255), nullable=True)

    contact_email = db.Column(db.Boolean, default=False)
    contact_phone = db.Column(db.Boolean, default=False)
    contact_mail = db.Column(db.Boolean, default=False)
    contact_sms = db.Column(db.Boolean, default=False)

    registration_status = db.Column(db.String(50), nullable=True)
    voter_registration_id = db.Column(db.String(100), unique=True, nullable=True, index=True)
    registration_date = db.Column(db.Date, nullable=True)
    party_affiliation = db.Column(db.String(100), nullable=True)

    engagement_score = db.Column(db.Integer, default=0)
    last_contacted_date = db.Column(db.DateTime(timezone=True), nullable=True)
    preferred_contact_method = db.Column(db.String(50), nullable=True)

    custom_fields = db.Column(db.JSON, nullable=True)

    source_campaign_id = db.Column(db.Integer, db.ForeignKey('campaigns.campaign_id', use_alter=True), nullable=True)
    source_campaign = db.relationship("Campaign", back_populates='sourced_voters', foreign_keys='Voter.source_campaign_id')

    campaigns_association = db.relationship('CampaignVoter', back_populates='voter', lazy='dynamic', cascade="all, delete-orphan")

    interactions = db.relationship('Interaction', backref='voter', lazy='dynamic', cascade="all, delete-orphan")

    survey_responses = db.relationship('SurveyResult', back_populates='voter', lazy='dynamic', cascade="all, delete-orphan")

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
            'contact_email': self.contact_email,
            'contact_phone': self.contact_phone,
            'contact_mail': self.contact_mail,
            'contact_sms': self.contact_sms,
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

    campaign_voter_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    campaign_id = db.Column(db.Integer, db.ForeignKey('campaigns.campaign_id', ondelete='CASCADE', use_alter=True), nullable=False)
    voter_id = db.Column(db.Integer, db.ForeignKey('voters.voter_id', ondelete='CASCADE'), nullable=False)
    added_at = db.Column(db.DateTime(timezone=True), server_default=db.func.now())

    campaign = db.relationship('Campaign', back_populates='voters_association')
    voter = db.relationship('Voter', back_populates='campaigns_association')

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
