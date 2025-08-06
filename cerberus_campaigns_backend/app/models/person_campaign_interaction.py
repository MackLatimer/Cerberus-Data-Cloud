from sqlalchemy import Column, Integer, String, Date, DECIMAL, Boolean, TIMESTAMP, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import JSONB

Base = declarative_base()

class PersonCampaignInteraction(Base):
    __tablename__ = 'person_campaign_interactions'

    interaction_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    campaign_id = Column(Integer, ForeignKey('campaigns.campaign_id', ondelete='CASCADE'), nullable=False)
    interaction_type = Column(Enum('ContactForm', 'Donation', 'Endorsement', 'Volunteer', 'Other', name='interaction_type_enum'))
    interaction_date = Column(Date)
    amount = Column(DECIMAL(10,2))
    follow_up_needed = Column(Boolean, default=False)
    details = Column(JSONB)
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())