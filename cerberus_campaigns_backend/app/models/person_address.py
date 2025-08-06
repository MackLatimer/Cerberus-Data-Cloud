from sqlalchemy import Column, Integer, String, Date, Boolean, TIMESTAMP, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class PersonAddress(Base):
    __tablename__ = 'person_addresses'

    person_address_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    address_id = Column(Integer, ForeignKey('addresses.address_id', ondelete='CASCADE'), nullable=False)
    address_type = Column(Enum('Home', 'Work', 'Mailing', 'Other', name='address_type_enum'))
    confidence_score = Column(Integer, default=100)
    is_current = Column(Boolean, default=True)
    start_date = Column(Date)
    end_date = Column(Date)
    occupancy_status = Column(Enum('Owner', 'Renter', 'Temporary', 'Unknown', name='occupancy_status_enum'), default='Unknown')
    move_in_date = Column(Date)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())