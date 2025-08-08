from ..extensions import db

class Subscription(db.Model):
    __tablename__ = 'subscriptions'

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String, unique=True, nullable=False)
    filter_settings = db.Column(db.JSON, nullable=False)
    active = db.Column(db.Boolean, default=True)
    last_checked = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
