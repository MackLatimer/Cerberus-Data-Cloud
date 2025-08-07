from ..extensions import db

class AddressDistrict(db.Model):
    __tablename__ = 'address_districts'

    address_district_id = db.Column(db.Integer, primary_key=True)
    address_id = db.Column(db.Integer, nullable=False)
    district_id = db.Column(db.Integer, nullable=False)
    is_active = db.Column(db.Boolean, default=True)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['address_id'], ['addresses.address_id'], name='fk_address_districts_address_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['district_id'], ['districts.district_id'], name='fk_address_districts_district_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_address_districts_source_id'),
        db.UniqueConstraint('address_id', 'district_id', name='uq_address_district'),
    )