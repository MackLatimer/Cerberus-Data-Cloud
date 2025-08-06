from sqlalchemy import Column, Integer, String, Text, TIMESTAMP, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class PersonOtherContact(Base):
    __tablename__ = 'person_other_contacts'

    contact_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    contact_type = Column(String(100))
    contact_value = Column(Text)
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())