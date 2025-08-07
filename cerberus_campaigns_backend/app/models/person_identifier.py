from ..extensions import db
from sqlalchemy import TypeDecorator, LargeBinary
from sqlalchemy.sql import func, expression

class EncryptedString(TypeDecorator):
    impl = LargeBinary

    def process_bind_param(self, value, dialect):
        if value is not None:
            # Encrypt the string using pgcrypto's pgp_sym_encrypt
            # The 'secret_key' should be loaded from a secure configuration
            return expression.cast(func.pgp_sym_encrypt(value, 'your_secret_key'), LargeBinary)
        return value

    def process_result_value(self, value, dialect):
        if value is not None:
            # Decrypt the string using pgcrypto's pgp_sym_decrypt
            return func.pgp_sym_decrypt(value, 'your_secret_key').astext
        return value

class PersonIdentifier(db.Model):
    __tablename__ = 'person_identifiers'

    identifier_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    identifier_type = db.Column(db.String(50), nullable=False)
    identifier_value = db.Column(EncryptedString, unique=True, nullable=False)  # Encrypted
    confidence_score = db.Column(db.Integer, default=100)
    issue_date = db.Column(db.Date)
    expiration_date = db.Column(db.Date)
    verification_status = db.Column(db.Enum('Verified', 'Pending', 'Invalid', name='verification_status_enum'), default='Pending')
    source_id = db.Column(db.Integer)
    source = db.Column(db.String(255))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_person_identifiers_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_person_identifiers_source_id'),
    )