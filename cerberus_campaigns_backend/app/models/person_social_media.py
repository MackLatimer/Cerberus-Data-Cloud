from ..extensions import db

class PersonSocialMedia(db.Model):
    __tablename__ = 'person_social_media'

    social_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, db.ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    platform = db.Column(db.String(50))
    handle = db.Column(db.String(255), unique=True)
    confidence_score = db.Column(db.Integer, default=100)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())