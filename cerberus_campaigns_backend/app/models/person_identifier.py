from sqlalchemy import Column, Integer, String, Date, TIMESTAMP, Enum, ForeignKey, TypeDecorator, LargeBinary
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func, expression
from sqlalchemy.dialects import postgresql

Base = declarative_base()

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

class PersonIdentifier(Base):
    __tablename__ = 'person_identifiers'

    identifier_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    identifier_type = Column(String(50), nullable=False)
    identifier_value = Column(EncryptedString, unique=True, nullable=False)  # Encrypted
    confidence_score = Column(Integer, default=100)
    issue_date = Column(Date)
    expiration_date = Column(Date)
    verification_status = Column(Enum('Verified', 'Pending', 'Invalid', name='verification_status_enum'), default='Pending')
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    source = Column(String(255))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())