from sqlalchemy import Column, Integer, String, TIMESTAMP, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from .person_identifier import EncryptedString # Reusing the custom type

Base = declarative_base()

class PersonPhone(Base):
    __tablename__ = 'person_phones'

    phone_id = Column(Integer, primary_key=True)
    person_id = Column(Integer, ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    phone_number = Column(EncryptedString, unique=True) # Encrypted
    phone_type = Column(Enum('Mobile', 'Home', 'Work', 'Other', name='phone_type_enum'))
    confidence_score = Column(Integer, default=100)
    is_verified = Column(Boolean, default=False)
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())

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