from ..extensions import db
from .person_identifier import EncryptedString # Reusing the custom type

class Donation(db.Model):
    __tablename__ = 'donations'

    id = db.Column(db.Integer, primary_key=True)
    amount = db.Column(db.DECIMAL(10,2), nullable=False)
    currency = db.Column(db.String(3), default='USD')
    payment_status = db.Column(db.Enum('succeeded', 'pending', 'failed', 'requires_payment_method', 'requires_confirmation', name='payment_status_enum'), default='pending')
    stripe_payment_intent_id = db.Column(db.String(255), unique=True, nullable=False)
    first_name = db.Column(db.String(255))
    last_name = db.Column(db.String(255))
    address_line1 = db.Column(db.String(255))
    address_line2 = db.Column(db.String(255))
    address_city = db.Column(db.String(100))
    address_state = db.Column(db.String(50))
    address_zip = db.Column(db.String(20))
    employer = db.Column(db.String(255))
    occupation = db.Column(db.String(255))
    email = db.Column(EncryptedString) # Encrypted
    phone_number = db.Column(EncryptedString) # Encrypted
    contact_email = db.Column(db.Boolean, default=False)
    contact_phone = db.Column(db.Boolean, default=False)
    contact_mail = db.Column(db.Boolean, default=False)
    contact_sms = db.Column(db.Boolean, default=False)
    is_recurring = db.Column(db.Boolean, default=False)
    covers_fees = db.Column(db.Boolean, default=False)
    person_id = db.Column(db.Integer, db.ForeignKey('persons.person_id', ondelete='SET NULL'))
    campaign_id = db.Column(db.Integer, db.ForeignKey('campaigns.campaign_id', ondelete='CASCADE'), nullable=False)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

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
