from sqlalchemy import Column, Integer, String, TIMESTAMP, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import JSONB
from .person_identifier import EncryptedString # Reusing the custom type

Base = declarative_base()

class PersonPaymentInfo(Base):
    __tablename__ = 'person_payment_info'

    payment_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    payment_type = Column(Enum('CreditCard', 'BankAccount', 'PayPal', 'Other', name='payment_type_enum'))
    details = Column(EncryptedString)  # Encrypted JSONB
    confidence_score = Column(Integer, default=100)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())