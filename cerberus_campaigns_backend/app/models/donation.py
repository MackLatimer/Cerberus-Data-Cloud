from datetime import datetime
from app.extensions import db

class Donation(db.Model):
    __tablename__ = 'donations'

    id = db.Column("id", db.Integer, primary_key=True)
    amount = db.Column("amount", db.Float, nullable=False)
    currency = db.Column("currency", db.String(10), default='usd', nullable=False)
    payment_status = db.Column("payment_status", db.String(50), default='pending', nullable=False)
    stripe_payment_intent_id = db.Column("stripe_payment_intent_id", db.String(255), unique=True, nullable=False)
    first_name = db.Column("first_name", db.String(100))
    last_name = db.Column("last_name", db.String(100))
    address_line1 = db.Column("address_line1", db.String(255))
    address_line2 = db.Column("address_line2", db.String(255))
    address_city = db.Column("address_city", db.String(100))
    address_state = db.Column("address_state", db.String(100))
    address_zip = db.Column("address_zip", db.String(20))
    employer = db.Column("employer", db.String(255))
    occupation = db.Column("occupation", db.String(255))
    email = db.Column("email", db.String(255))
    phone_number = db.Column("phone_number", db.String(50))
    contact_email = db.Column("contact_email", db.Boolean, default=False)
    contact_phone = db.Column("contact_phone", db.Boolean, default=False)
    contact_mail = db.Column("contact_mail", db.Boolean, default=False)
    contact_sms = db.Column("contact_sms", db.Boolean, default=False)
    is_recurring = db.Column("is_recurring", db.Boolean, default=False)
    covers_fees = db.Column("covers_fees", db.Boolean, default=False)
    created_at = db.Column("created_at", db.DateTime, default=datetime.utcnow)
    updated_at = db.Column("updated_at", db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f"<Donation {self.id} - {self.amount} {self.currency} - {self.payment_status}>"
