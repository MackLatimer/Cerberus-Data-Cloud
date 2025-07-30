from datetime import datetime
from app.extensions import db

class Donation(db.Model):
    __tablename__ = 'donations'

    id = db.Column(db.Integer, primary_key=True)
    stripe_payment_intent_id = db.Column(db.String(255), unique=True, nullable=False)
    amount = db.Column(db.Float, nullable=False)
    currency = db.Column(db.String(10), default='usd', nullable=False)
    payment_status = db.Column(db.String(50), default='pending', nullable=False)
    # Donor information (collected after initial payment)
    first_name = db.Column(db.String(100), nullable=True)
    last_name = db.Column(db.String(100), nullable=True)
    address_line1 = db.Column(db.String(255), nullable=True)
    address_line2 = db.Column(db.String(255), nullable=True)
    address_city = db.Column(db.String(100), nullable=True)
    address_state = db.Column(db.String(100), nullable=True)
    address_zip = db.Column(db.String(20), nullable=True)
    employer = db.Column(db.String(255), nullable=True)
    occupation = db.Column(db.String(255), nullable=True)
    email = db.Column(db.String(255), nullable=True)
    phone_number = db.Column(db.String(50), nullable=True)
    # Contact preferences (checkboxes)
    contact_email = db.Column(db.Boolean, default=False)
    contact_phone = db.Column(db.Boolean, default=False)
    contact_mail = db.Column(db.Boolean, default=False)
    contact_sms = db.Column(db.Boolean, default=False)

    # New fields for Stripe Payment Intents and recurring donations
    is_recurring = db.Column(db.Boolean, default=False)
    covers_fees = db.Column(db.Boolean, default=False)
    stripe_customer_id = db.Column(db.String(255), nullable=True)
    stripe_payment_intent_id = db.Column(db.String(255), unique=True, nullable=True)
    stripe_subscription_id = db.Column(db.String(255), unique=True, nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f"<Donation {self.id} - {self.amount} {self.currency} - {self.payment_status}>"
