from sqlalchemy import Column, Integer, String, Text, DECIMAL, TIMESTAMP, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class Position(Base):
    __tablename__ = 'positions'

    position_id = Column(Integer, primary_key=True)
    body_id = Column(Integer, ForeignKey('government_bodies.body_id', ondelete='CASCADE'), nullable=False)
    position_title = Column(String(255))
    term_length = Column(Integer)
    salary = Column(DECIMAL(10,2))
    requirements = Column(Text)
    current_holder_person_id = Column(Integer, ForeignKey('persons.person_id'))
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())