from sqlalchemy import Column, Integer, String, Date, Boolean, TIMESTAMP, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import JSONB

Base = declarative_base()

class VoterHistory(Base):
    __tablename__ = 'voter_history'

    history_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    election_date = Column(Date)
    election_type = Column(String(100))
    voted = Column(Boolean)
    voting_method = Column(Enum('InPerson', 'Mail', 'Absentee', 'Other', name='voting_method_enum'))
    turnout_reason = Column(String)
    survey_link_id = Column(Integer, ForeignKey('survey_results.survey_id'))
    details = Column(JSONB)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())