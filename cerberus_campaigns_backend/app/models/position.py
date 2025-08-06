from ..extensions import db

class Position(db.Model):
    __tablename__ = 'positions'

    position_id = db.Column(db.Integer, primary_key=True)
    body_id = db.Column(db.Integer, db.ForeignKey('government_bodies.body_id', ondelete='CASCADE'), nullable=False)
    position_title = db.Column(db.String(255))
    term_length = db.Column(db.Integer)
    salary = db.Column(db.DECIMAL(10,2))
    requirements = db.Column(db.Text)
    current_holder_person_id = db.Column(db.Integer, db.ForeignKey('persons.person_id'))
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())