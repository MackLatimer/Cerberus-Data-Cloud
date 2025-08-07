from ..extensions import db
from sqlalchemy import LargeBinary, func
from sqlalchemy.ext.hybrid import hybrid_property
from ..config import current_config

class PersonEmail(db.Model):
    __tablename__ = 'person_emails'

    email_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    _email = db.Column("email", LargeBinary, unique=True)
    email_type = db.Column(db.Enum('Personal', 'Work', 'Other', name='email_type_enum'))
    confidence_score = db.Column(db.Integer, default=100)
    is_verified = db.Column(db.Boolean, default=False)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    @hybrid_property
    def email(self):
        if self._email is not None:
            return db.session.scalar(func.pgp_sym_decrypt(self._email, current_config.PGCRYPTO_SECRET_KEY))
        return None

    @email.setter
    def email(self, value):
        if value is not None:
            self._email = db.session.scalar(func.pgp_sym_encrypt(value, current_config.PGCRYPTO_SECRET_KEY))
        else:
            self._email = None
    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_person_emails_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_person_emails_source_id'),
    )

    def to_dict(self):
        return {
            "email_id": self.email_id,
            "person_id": self.person_id,
            "email": self.email,
            "email_type": self.email_type.value if self.email_type else None,
            "confidence_score": self.confidence_score,
            "is_verified": self.is_verified,
            "source_id": self.source_id,
            "created_at": str(self.created_at),
            "updated_at": str(self.updated_at),
        }