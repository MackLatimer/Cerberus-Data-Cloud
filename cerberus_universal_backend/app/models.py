from sqlalchemy import (
    Column, Integer, String, Date, Boolean, JSON, TIMESTAMP, Enum, ForeignKey,
    DECIMAL, TEXT, UniqueConstraint
)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import JSONB, TSVECTOR
from geoalchemy2 import Geometry

Base = declarative_base()

class DataSource(Base):
    __tablename__ = 'data_sources'
    source_id = Column(Integer, primary_key=True)
    source_name = Column(String(255))
    source_type = Column(String(50), default='Manual')
    api_endpoint = Column(String(255))
    import_date = Column(Date)
    description = Column(TEXT)
    data_retention_period = Column(Integer)
    created_at = Column(TIMESTAMP, default=func.current_timestamp())

class Person(Base):
    __tablename__ = 'persons'
    person_id = Column(Integer, primary_key=True)
    first_name = Column(String(255))
    last_name = Column(String(255))
    date_of_birth = Column(Date)
    gender = Column(String(50))
    party_affiliation = Column(String(100))
    ethnicity = Column(String(100))
    income_bracket = Column(String(50))
    education_level = Column(String(100))
    voter_propensity_score = Column(Integer)
    registration_status = Column(String(50), default='Active')
    status_change_date = Column(Date)
    consent_opt_in = Column(Boolean, default=False)
    duplicate_flag = Column(Boolean, default=False)
    last_contact_date = Column(Date)
    ml_tags = Column(JSONB)
    change_history = Column(JSONB)
    preferred_contact_method = Column(String(50))
    language_preference = Column(String(50))
    accessibility_needs = Column(TEXT)
    last_updated_by = Column(String(255))
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    source = relationship("DataSource")
    addresses = relationship("PersonAddress", back_populates="person")
    emails = relationship("PersonEmail", back_populates="person")
    phones = relationship("PersonPhone", back_populates="person")
    social_media = relationship("PersonSocialMedia", back_populates="person")
    employers = relationship("PersonEmployer", back_populates="person")
    payment_infos = relationship("PersonPaymentInfo", back_populates="person")
    other_contacts = relationship("PersonOtherContact", back_populates="person")
    voter_history = relationship("VoterHistory", back_populates="person")
    survey_results = relationship("SurveyResult", back_populates="person")
    relationships1 = relationship("PersonRelationship", foreign_keys='PersonRelationship.person_id1', back_populates="person1")
    relationships2 = relationship("PersonRelationship", foreign_keys='PersonRelationship.person_id2', back_populates="person2")
    campaign_interactions = relationship("PersonCampaignInteraction", back_populates="person")
    donations = relationship("Donation", back_populates="person")
    merges_from = relationship("PersonMerge", foreign_keys='PersonMerge.merged_from_person_id', back_populates="merged_from")
    merges_to = relationship("PersonMerge", foreign_keys='PersonMerge.merged_to_person_id', back_populates="merged_to")

class PartyAffiliationHistory(Base):
    __tablename__ = 'party_affiliation_history'
    history_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    party_affiliation = Column(String(100))
    valid_from = Column(Date, nullable=False)
    valid_to = Column(Date)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())

    person = relationship("Person")
    source = relationship("DataSource")

class PersonIdentifier(Base):
    __tablename__ = 'person_identifiers'
    identifier_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    identifier_type = Column(String(50), nullable=False)
    identifier_value = Column(String(255), nullable=False, unique=True)
    confidence_score = Column(Integer, default=100)
    issue_date = Column(Date)
    expiration_date = Column(Date)
    verification_status = Column(String(50), default='Pending')
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    source = Column(String(255))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person")
    data_source = relationship("DataSource")

class Address(Base):
    __tablename__ = 'addresses'
    address_id = Column(Integer, primary_key=True)
    street = Column(String(255))
    city = Column(String(100))
    state = Column(String(50))
    zip_code = Column(String(20))
    country = Column(String(50), default='USA')
    latitude = Column(DECIMAL(10, 7))
    longitude = Column(DECIMAL(10, 7))
    census_block = Column(String(50))
    ward = Column(String(50))
    geom = Column(Geometry('POINT', srid=4326))
    mail_forwarding_info = Column(TEXT)
    parent_address_id = Column(Integer, ForeignKey('addresses.address_id'))
    metadata = Column(JSONB)
    change_history = Column(JSONB)
    enrichment_status = Column(String(50), default='Pending')
    property_type = Column(String(50))
    delivery_point_code = Column(String(10))
    last_validated_date = Column(Date)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    source = relationship("DataSource")
    parent_address = relationship("Address", remote_side=[address_id])
    districts = relationship("AddressDistrict", back_populates="address")

class PersonAddress(Base):
    __tablename__ = 'person_addresses'
    person_address_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    address_id = Column(Integer, ForeignKey('addresses.address_id', ondelete='CASCADE'), nullable=False)
    address_type = Column(String(50))
    confidence_score = Column(Integer, default=100)
    is_current = Column(Boolean, default=True)
    start_date = Column(Date)
    end_date = Column(Date)
    occupancy_status = Column(String(50), default='Unknown')
    move_in_date = Column(Date)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="addresses")
    address = relationship("Address")
    source = relationship("DataSource")
    __table_args__ = (UniqueConstraint('person_id', 'address_id'),)

class PersonEmail(Base):
    __tablename__ = 'person_emails'
    email_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    email = Column(String(255), unique=True)
    email_type = Column(String(50))
    confidence_score = Column(Integer, default=100)
    is_verified = Column(Boolean, default=False)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="emails")
    source = relationship("DataSource")

class PersonPhone(Base):
    __tablename__ = 'person_phones'
    phone_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    phone_number = Column(String(50), unique=True)
    phone_type = Column(String(50))
    confidence_score = Column(Integer, default=100)
    is_verified = Column(Boolean, default=False)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="phones")
    source = relationship("DataSource")

class PersonSocialMedia(Base):
    __tablename__ = 'person_social_media'
    social_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    platform = Column(String(50))
    handle = Column(String(255), unique=True)
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="social_media")
    source = relationship("DataSource")

class PersonEmployer(Base):
    __tablename__ = 'person_employers'
    employer_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    employer_name = Column(String(255))
    occupation = Column(String(255))
    start_date = Column(Date)
    end_date = Column(Date)
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="employers")
    source = relationship("DataSource")

class PersonPaymentInfo(Base):
    __tablename__ = 'person_payment_info'
    payment_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    payment_type = Column(String(50))
    details = Column(JSONB)
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="payment_infos")
    source = relationship("DataSource")

class PersonOtherContact(Base):
    __tablename__ = 'person_other_contacts'
    contact_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    contact_type = Column(String(100))
    contact_value = Column(TEXT)
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="other_contacts")
    source = relationship("DataSource")

class SurveyResult(Base):
    __tablename__ = 'survey_results'
    survey_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    survey_date = Column(Date)
    survey_source = Column(String(255))
    responses = Column(JSONB)
    search_vector = Column(TSVECTOR)
    confidence_score = Column(Integer, default=100)
    response_time = Column(Integer)
    survey_channel = Column(String(50))
    completion_status = Column(String(50), default='Complete')
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="survey_results")
    source = relationship("DataSource")

class VoterHistory(Base):
    __tablename__ = 'voter_history'
    history_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    election_date = Column(Date, primary_key=True, nullable=False)
    election_type = Column(String(100))
    voted = Column(Boolean)
    voting_method = Column(String(50))
    turnout_reason = Column(TEXT)
    survey_link_id = Column(Integer, ForeignKey('survey_results.survey_id'))
    details = Column(JSONB)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="voter_history")
    survey = relationship("SurveyResult")
    source = relationship("DataSource")

class PersonRelationship(Base):
    __tablename__ = 'person_relationships'
    relationship_id = Column(Integer, primary_key=True)
    person_id1 = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    person_id2 = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    relationship_type = Column(String(50))
    details = Column(TEXT)
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person1 = relationship("Person", foreign_keys=[person_id1], back_populates="relationships1")
    person2 = relationship("Person", foreign_keys=[person_id2], back_populates="relationships2")
    source = relationship("DataSource")
    __table_args__ = (UniqueConstraint('person_id1', 'person_id2'),)

class District(Base):
    __tablename__ = 'districts'
    district_id = Column(Integer, primary_key=True)
    district_name = Column(String(255))
    district_type = Column(String(50))
    boundaries = Column(JSONB)
    geom = Column(Geometry('MULTIPOLYGON', srid=4326))
    district_code = Column(String(50))
    election_cycle = Column(String(50))
    population_estimate = Column(Integer)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    source = relationship("DataSource")
    addresses = relationship("AddressDistrict", back_populates="district")

class AddressDistrict(Base):
    __tablename__ = 'address_districts'
    address_district_id = Column(Integer, primary_key=True)
    address_id = Column(Integer, ForeignKey('addresses.address_id', ondelete='CASCADE'), nullable=False)
    district_id = Column(Integer, ForeignKey('districts.district_id', ondelete='CASCADE'), nullable=False)
    is_active = Column(Boolean, default=True)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    address = relationship("Address", back_populates="districts")
    district = relationship("District", back_populates="addresses")
    source = relationship("DataSource")
    __table_args__ = (UniqueConstraint('address_id', 'district_id'),)

class Campaign(Base):
    __tablename__ = 'campaigns'
    campaign_id = Column(Integer, primary_key=True)
    campaign_name = Column(String(255))
    start_date = Column(Date)
    end_date = Column(Date)
    campaign_type = Column(String(50))
    details = Column(JSONB)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    source = relationship("DataSource")
    interactions = relationship("PersonCampaignInteraction", back_populates="campaign")
    donations = relationship("Donation", back_populates="campaign")

class PersonCampaignInteraction(Base):
    __tablename__ = 'person_campaign_interactions'
    interaction_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    campaign_id = Column(Integer, ForeignKey('campaigns.campaign_id', ondelete='CASCADE'), nullable=False)
    interaction_type = Column(String(50))
    interaction_date = Column(Date)
    amount = Column(DECIMAL(10, 2))
    follow_up_needed = Column(Boolean, default=False)
    details = Column(JSONB)
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="campaign_interactions")
    campaign = relationship("Campaign", back_populates="interactions")
    source = relationship("DataSource")

class GovernmentBody(Base):
    __tablename__ = 'government_bodies'
    body_id = Column(Integer, primary_key=True)
    body_name = Column(String(255))
    jurisdiction = Column(String(100))
    details = Column(JSONB)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    source = relationship("DataSource")
    positions = relationship("Position", back_populates="government_body")

class Position(Base):
    __tablename__ = 'positions'
    position_id = Column(Integer, primary_key=True)
    body_id = Column(Integer, ForeignKey('government_bodies.body_id', ondelete='CASCADE'), nullable=False)
    position_title = Column(String(255))
    term_length = Column(Integer)
    salary = Column(DECIMAL(10, 2))
    requirements = Column(TEXT)
    current_holder_person_id = Column(Integer, ForeignKey('persons.person_id'))
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    government_body = relationship("GovernmentBody", back_populates="positions")
    current_holder = relationship("Person")
    source = relationship("DataSource")

class Donation(Base):
    __tablename__ = 'donations'
    id = Column(Integer, primary_key=True)
    amount = Column(DECIMAL(10, 2), nullable=False)
    currency = Column(String(3), default='USD')
    payment_status = Column(String(50), default='pending')
    stripe_payment_intent_id = Column(String(255), unique=True, nullable=False)
    first_name = Column(String(255))
    last_name = Column(String(255))
    address_line1 = Column(String(255))
    address_line2 = Column(String(255))
    address_city = Column(String(100))
    address_state = Column(String(50))
    address_zip = Column(String(20))
    employer = Column(String(255))
    occupation = Column(String(255))
    email = Column(String(255))
    phone_number = Column(String(50))
    contact_email = Column(Boolean, default=False)
    contact_phone = Column(Boolean, default=False)
    contact_mail = Column(Boolean, default=False)
    contact_sms = Column(Boolean, default=False)
    is_recurring = Column(Boolean, default=False)
    covers_fees = Column(Boolean, default=False)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='SET NULL'))
    campaign_id = Column(Integer, ForeignKey('campaigns.campaign_id', ondelete='CASCADE'), nullable=False)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP)

    person = relationship("Person", back_populates="donations")
    campaign = relationship("Campaign", back_populates="donations")
    source = relationship("DataSource")

class PersonMerge(Base):
    __tablename__ = 'person_merges'
    merge_id = Column(Integer, primary_key=True)
    merged_from_person_id = Column(Integer, ForeignKey('persons.person_id'), nullable=False)
    merged_to_person_id = Column(Integer, ForeignKey('persons.person_id'), nullable=False)
    merge_date = Column(Date, default=func.current_date())
    merge_reason = Column(TEXT)
    merge_confidence = Column(Integer)
    merge_method = Column(String(50), default='Manual')
    created_at = Column(TIMESTAMP, default=func.current_timestamp())

    merged_from = relationship("Person", foreign_keys=[merged_from_person_id], back_populates="merges_from")
    merged_to = relationship("Person", foreign_keys=[merged_to_person_id], back_populates="merges_to")
