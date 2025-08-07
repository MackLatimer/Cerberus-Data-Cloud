from ..extensions import db
from sqlalchemy import TypeDecorator, LargeBinary, func
from ..config import current_config

class EncryptedString(TypeDecorator):
    impl = LargeBinary

    def __init__(self, *args, **kwargs):
        self.key = current_config.PGCRYPTO_SECRET_KEY
        super(EncryptedString, self).__init__(*args, **kwargs)

    def process_bind_param(self, value, dialect):
        if value is not None:
            return func.pgp_sym_encrypt(value, self.key)
        return value

    def process_result_value(self, value, dialect):
        if value is not None:
            # The value is returned as a memoryview, so we need to convert it to bytes
            return bytes(value).decode('utf-8')
        return value

    def column_expression(self, col):
        return func.pgp_sym_decrypt(col, self.key, cast_as='text')

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