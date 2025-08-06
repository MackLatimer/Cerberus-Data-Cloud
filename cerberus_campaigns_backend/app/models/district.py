from ..extensions import db
from geoalchemy2 import Geometry

class District(db.Model):
    __tablename__ = 'districts'

    district_id = db.Column(db.Integer, primary_key=True)
    district_name = db.Column(db.String(255))
    district_type = db.Column(db.Enum('Federal', 'State', 'Local', 'Special', name='district_type_enum'))
    boundaries = db.Column(db.JSON)
    geom = db.Column(Geometry(geometry_type='MULTIPOLYGON', srid=4326))
    district_code = db.Column(db.String(50))
    election_cycle = db.Column(db.String(50))
    population_estimate = db.Column(db.Integer)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())