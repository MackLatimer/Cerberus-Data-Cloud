from ..extensions import db
from sqlalchemy import LargeBinary, func
from sqlalchemy.ext.hybrid import hybrid_property
from ..config import current_config

class PersonIdentifier(db.Model):
    __tablename__ = 'person_identifiers'

    identifier_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    identifier_type = db.Column(db.String(50), nullable=False)
    _identifier_value = db.Column("identifier_value", LargeBinary, unique=True, nullable=False)
    confidence_score = db.Column(db.Integer, default=100)
    issue_date = db.Column(db.Date)
    expiration_date = db.Column(db.Date)
    verification_status = db.Column(db.Enum('Verified', 'Pending', 'Invalid', name='verification_status_enum'), default='Pending')
    source_id = db.Column(db.Integer)
    source = db.Column(db.String(255))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    @hybrid_property
    def identifier_value(self):
        if self._identifier_value is not None:
            return db.session.scalar(func.pgp_sym_decrypt(self._identifier_value, current_config.PGCRYPTO_SECRET_KEY))
        return None

    @identifier_value.setter
    def identifier_value(self, value):
        if value is not None:
            self._identifier_value = db.session.scalar(func.pgp_sym_encrypt(value, current_config.PGCRYPTO_SECRET_KEY))
        else:
            self._identifier_value = None

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_person_identifiers_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_person_identifiers_source_id'),
    )