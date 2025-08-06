from sqlalchemy import Column, Integer, String, Date, TIMESTAMP, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import JSONB, TSVECTOR

Base = declarative_base()

class SurveyResult(Base):
    __tablename__ = 'survey_results'

    survey_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    survey_date = Column(Date)
    survey_source = Column(String(255))
    responses = Column(JSONB)
    search_vector = Column(TSVECTOR) # This will be populated by a trigger
    confidence_score = Column(Integer, default=100)
    response_time = Column(Integer)
    survey_channel = Column(Enum('Online', 'Phone', 'InPerson', 'Mail', name='survey_channel_enum'))
    completion_status = Column(Enum('Complete', 'Partial', 'Abandoned', name='completion_status_enum'), default='Complete')
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())