from ..extensions import db
from sqlalchemy import LargeBinary, func
from sqlalchemy.ext.hybrid import hybrid_property
from ..config import current_config

class PersonPhone(db.Model):
    __tablename__ = 'person_phones'

    phone_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    _phone_number = db.Column("phone_number", LargeBinary, unique=True)
    phone_type = db.Column(db.Enum('Mobile', 'Home', 'Work', 'Other', name='phone_type_enum'))
    confidence_score = db.Column(db.Integer, default=100)
    is_verified = db.Column(db.Boolean, default=False)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    @hybrid_property
    def phone_number(self):
        if self._phone_number is not None:
            return db.session.scalar(func.pgp_sym_decrypt(self._phone_number, current_config.PGCRYPTO_SECRET_KEY))
        return None

    @phone_number.setter
    def phone_number(self, value):
        if value is not None:
            self._phone_number = db.session.scalar(func.pgp_sym_encrypt(value, current_config.PGCRYPTO_SECRET_KEY))
        else:
            self._phone_number = None

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_person_phones_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_person_phones_source_id'),
    )

    def to_dict(self):
        return {
            "phone_id": self.phone_id,
            "person_id": self.person_id,
            "phone_number": self.phone_number,
            "phone_type": self.phone_type.value if self.phone_type else None,
            "confidence_score": self.confidence_score,
            "is_verified": self.is_verified,
            "source_id": self.source_id,
            "created_at": str(self.created_at),
            "updated_at": str(self.updated_at),
        }