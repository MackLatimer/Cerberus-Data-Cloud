from sqlalchemy import Column, Integer, String, TIMESTAMP, Enum
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import JSONB
from geoalchemy2 import Geometry

Base = declarative_base()

class District(Base):
    __tablename__ = 'districts'

    district_id = Column(Integer, primary_key=True)
    district_name = Column(String(255))
    district_type = Column(Enum('Federal', 'State', 'Local', 'Special', name='district_type_enum'))
    boundaries = Column(JSONB)
    geom = Column(Geometry(geometry_type='MULTIPOLYGON', srid=4326))
    district_code = Column(String(50))
    election_cycle = Column(String(50))
    population_estimate = Column(Integer)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())