from ..extensions import db
from .person_identifier import EncryptedString # Reusing the custom type

class PersonPaymentInfo(db.Model):
    __tablename__ = 'person_payment_info'

    payment_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    payment_type = db.Column(db.Enum('CreditCard', 'BankAccount', 'PayPal', 'Other', name='payment_type_enum'))
    details = db.Column(EncryptedString)  # Encrypted JSONB
    confidence_score = db.Column(db.Integer, default=100)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_person_payment_info_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_person_payment_info_source_id'),
    )