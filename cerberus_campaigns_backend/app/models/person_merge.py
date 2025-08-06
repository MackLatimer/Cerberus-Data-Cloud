from sqlalchemy import Column, Integer, String, Date, TIMESTAMP, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class PersonMerge(Base):
    __tablename__ = 'person_merges'

    merge_id = Column(Integer, primary_key=True)
    merged_from_person_id = Column(Integer, ForeignKey('persons.person_id'), nullable=False)
    merged_to_person_id = Column(Integer, ForeignKey('persons.person_id'), nullable=False)
    merge_date = Column(Date, default=func.current_date())
    merge_reason = Column(String)
    merge_confidence = Column(Integer)
    merge_method = Column(Enum('Manual', 'Automated', name='merge_method_enum'), default='Manual')
    created_at = Column(TIMESTAMP, default=func.current_timestamp())