from ..extensions import db

class AddressDistrict(db.Model):
    __tablename__ = 'address_districts'

    address_district_id = db.Column(db.Integer, primary_key=True)
    address_id = db.Column(db.Integer, db.ForeignKey('addresses.address_id', ondelete='CASCADE'), nullable=False)
    district_id = db.Column(db.Integer, db.ForeignKey('districts.district_id', ondelete='CASCADE'), nullable=False)
    is_active = db.Column(db.Boolean, default=True)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (db.UniqueConstraint('address_id', 'district_id'),)