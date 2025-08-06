from ..extensions import db
from .person_identifier import EncryptedString # Reusing the custom type

class PersonPaymentInfo(db.Model):
    __tablename__ = 'person_payment_info'

    payment_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, db.ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    payment_type = db.Column(db.Enum('CreditCard', 'BankAccount', 'PayPal', 'Other', name='payment_type_enum'))
    details = db.Column(EncryptedString)  # Encrypted JSONB
    confidence_score = db.Column(db.Integer, default=100)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())