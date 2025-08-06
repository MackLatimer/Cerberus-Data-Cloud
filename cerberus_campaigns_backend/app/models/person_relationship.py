from sqlalchemy import Column, Integer, String, Text, TIMESTAMP, Enum, ForeignKey, UniqueConstraint
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class PersonRelationship(Base):
    __tablename__ = 'person_relationships'

    relationship_id = Column(Integer, primary_key=True)
    person_id1 = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    person_id2 = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    relationship_type = Column(Enum('Family', 'Spouse', 'Friend', 'Colleague', 'Other', name='relationship_type_enum'))
    details = Column(Text)
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())

    __table_args__ = (UniqueConstraint('person_id1', 'person_id2'),)