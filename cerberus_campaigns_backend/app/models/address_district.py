from sqlalchemy import Column, Integer, Boolean, TIMESTAMP, ForeignKey, UniqueConstraint
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class AddressDistrict(Base):
    __tablename__ = 'address_districts'

    address_district_id = Column(Integer, primary_key=True)
    address_id = Column(Integer, ForeignKey('addresses.address_id', ondelete='CASCADE'), nullable=False)
    district_id = Column(Integer, ForeignKey('districts.district_id', ondelete='CASCADE'), nullable=False)
    is_active = Column(Boolean, default=True)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())

    __table_args__ = (UniqueConstraint('address_id', 'district_id'),)