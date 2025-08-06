from sqlalchemy import Column, Integer, String, DECIMAL, Boolean, TIMESTAMP, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from .person_identifier import EncryptedString # Reusing the custom type

Base = declarative_base()

class Donation(Base):
    __tablename__ = 'donations'

    id = Column(Integer, primary_key=True)
    amount = Column(DECIMAL(10,2), nullable=False)
    currency = Column(String(3), default='USD')
    payment_status = Column(Enum('succeeded', 'pending', 'failed', 'requires_payment_method', 'requires_confirmation', name='payment_status_enum'), default='pending')
    stripe_payment_intent_id = Column(String(255), unique=True, nullable=False)
    first_name = Column(String(255))
    last_name = Column(String(255))
    address_line1 = Column(String(255))
    address_line2 = Column(String(255))
    address_city = Column(String(100))
    address_state = Column(String(50))
    address_zip = Column(String(20))
    employer = Column(String(255))
    occupation = Column(String(255))
    email = Column(EncryptedString) # Encrypted
    phone_number = Column(EncryptedString) # Encrypted
    contact_email = Column(Boolean, default=False)
    contact_phone = Column(Boolean, default=False)
    contact_mail = Column(Boolean, default=False)
    contact_sms = Column(Boolean, default=False)
    is_recurring = Column(Boolean, default=False)
    covers_fees = Column(Boolean, default=False)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='SET NULL'))
    campaign_id = Column(Integer, ForeignKey('campaigns.campaign_id', ondelete='CASCADE'), nullable=False)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())

    def to_dict(self):
        return {
            "id": self.id,
            "amount": str(self.amount),
            "currency": self.currency,
            "payment_status": self.payment_status.value if self.payment_status else None,
            "stripe_payment_intent_id": self.stripe_payment_intent_id,
            "first_name": self.first_name,
            "last_name": self.last_name,
            "address_line1": self.address_line1,
            "address_line2": self.address_line2,
            "address_city": self.address_city,
            "address_state": self.address_state,
            "address_zip": self.address_zip,
            "employer": self.employer,
            "occupation": self.occupation,
            "email": self.email,  # EncryptedString handles decryption on access
            "phone_number": self.phone_number,  # EncryptedString handles decryption on access
            "contact_email": self.contact_email,
            "contact_phone": self.contact_phone,
            "contact_mail": self.contact_mail,
            "contact_sms": self.contact_sms,
            "is_recurring": self.is_recurring,
            "covers_fees": self.covers_fees,
            "person_id": self.person_id,
            "campaign_id": self.campaign_id,
            "source_id": self.source_id,
            "created_at": str(self.created_at),
            "updated_at": str(self.updated_at),
        }
