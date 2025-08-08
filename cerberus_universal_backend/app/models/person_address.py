from ..extensions import db

class PersonAddress(db.Model):
    __tablename__ = 'person_addresses'

    person_address_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    address_id = db.Column(db.Integer, nullable=False)
    address_type = db.Column(db.Enum('Home', 'Work', 'Mailing', 'Other', name='address_type_enum'))
    confidence_score = db.Column(db.Integer, default=100)
    is_current = db.Column(db.Boolean, default=True)
    start_date = db.Column(db.Date)
    end_date = db.Column(db.Date)
    occupancy_status = db.Column(db.Enum('Owner', 'Renter', 'Temporary', 'Unknown', name='occupancy_status_enum'), default='Unknown')
    move_in_date = db.Column(db.Date)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_person_addresses_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['address_id'], ['addresses.address_id'], name='fk_person_addresses_address_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_person_addresses_source_id'),
    )