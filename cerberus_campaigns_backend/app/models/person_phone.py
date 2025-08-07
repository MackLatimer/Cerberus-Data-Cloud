from ..extensions import db
from .person_identifier import EncryptedString # Reusing the custom type

class PersonPhone(db.Model):
    __tablename__ = 'person_phones'

    phone_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    phone_number = db.Column(EncryptedString, unique=True) # Encrypted
    phone_type = db.Column(db.Enum('Mobile', 'Home', 'Work', 'Other', name='phone_type_enum'))
    confidence_score = db.Column(db.Integer, default=100)
    is_verified = db.Column(db.Boolean, default=False)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_person_phones_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_person_phones_source_id'),
    )

    def to_dict(self):
        return {
            "phone_id": self.phone_id,
            "person_id": self.person_id,
            "phone_number": self.phone_number, # EncryptedString handles decryption on access
            "phone_type": self.phone_type.value if self.phone_type else None,
            "confidence_score": self.confidence_score,
            "is_verified": self.is_verified,
            "source_id": self.source_id,
            "created_at": str(self.created_at),
            "updated_at": str(self.updated_at),
        }