from sqlalchemy import Column, Integer, String, TIMESTAMP, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class PersonSocialMedia(Base):
    __tablename__ = 'person_social_media'

    social_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    platform = Column(String(50))
    handle = Column(String(255), unique=True)
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())