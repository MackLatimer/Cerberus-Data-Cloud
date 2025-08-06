from sqlalchemy import Column, Integer, String, Date, DECIMAL, TIMESTAMP, ForeignKey, JSON
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import JSONB
from geoalchemy2 import Geometry

Base = declarative_base()

class Address(Base):
    __tablename__ = 'addresses'

    address_id = Column(Integer, primary_key=True)
    street = Column(String(255))
    city = Column(String(100))
    state = Column(String(50))
    zip_code = Column(String(20))
    country = Column(String(50), default='USA')
    latitude = Column(DECIMAL(10,7))
    longitude = Column(DECIMAL(10,7))
    census_block = Column(String(50))
    ward = Column(String(50))
    geom = Column(Geometry(geometry_type='POINT', srid=4326))
    mail_forwarding_info = Column(String)
    parent_address_id = Column(Integer, ForeignKey('addresses.address_id'))
    metadata = Column(JSONB)
    change_history = Column(JSONB)
    enrichment_status = Column(Enum('Pending', 'Enriched', 'Failed', name='enrichment_status_enum'), default='Pending')
    property_type = Column(Enum('Residential', 'Commercial', 'Mixed', 'Vacant', name='property_type_enum'))
    delivery_point_code = Column(String(10))
    last_validated_date = Column(Date)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())