from ..extensions import db

class PersonRelationship(db.Model):
    __tablename__ = 'person_relationships'

    relationship_id = db.Column(db.Integer, primary_key=True)
    person_id1 = db.Column(db.Integer, db.ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    person_id2 = db.Column(db.Integer, db.ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    relationship_type = db.Column(db.Enum('Family', 'Spouse', 'Friend', 'Colleague', 'Other', name='relationship_type_enum'))
    details = db.Column(db.Text)
    confidence_score = db.Column(db.Integer, default=100)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (db.UniqueConstraint('person_id1', 'person_id2'),)