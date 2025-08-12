from ..extensions import db
from sqlalchemy import JSON
from geoalchemy2 import Geometry

class Address(db.Model):
    __tablename__ = 'addresses'

    address_id = db.Column(db.Integer, primary_key=True)
    street = db.Column(db.String(255))
    city = db.Column(db.String(100))
    state = db.Column(db.String(50))
    zip_code = db.Column(db.String(20))
    country = db.Column(db.String(50), default='USA')
    latitude = db.Column(db.DECIMAL(10,7))
    longitude = db.Column(db.DECIMAL(10,7))
    census_block = db.Column(db.String(50))
    ward = db.Column(db.String(50))
    geom = db.Column(Geometry(geometry_type='POINT', srid=4326))
    mail_forwarding_info = db.Column(db.String)
    parent_address_id = db.Column(db.Integer)
    address_metadata = db.Column(db.JSON)
    change_history = db.Column(db.JSON)
    enrichment_status = db.Column(db.Enum('Pending', 'Enriched', 'Failed', name='enrichment_status_enum'), default='Pending')
    property_type = db.Column(db.Enum('Residential', 'Commercial', 'Mixed', 'Vacant', name='property_type_enum'))
    delivery_point_code = db.Column(db.String(10))
    last_validated_date = db.Column(db.Date)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['parent_address_id'], ['addresses.address_id'], name='fk_addresses_parent_address_id'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_addresses_source_id'),
    )