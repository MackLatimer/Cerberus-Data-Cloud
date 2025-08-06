from ..extensions import db

class PersonOtherContact(db.Model):
    __tablename__ = 'person_other_contacts'

    contact_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, db.ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    contact_type = db.Column(db.String(100))
    contact_value = db.Column(db.Text)
    confidence_score = db.Column(db.Integer, default=100)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())