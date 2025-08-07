from ..extensions import db

class PersonRelationship(db.Model):
    __tablename__ = 'person_relationships'

    relationship_id = db.Column(db.Integer, primary_key=True)
    person_id1 = db.Column(db.Integer, nullable=False)
    person_id2 = db.Column(db.Integer, nullable=False)
    relationship_type = db.Column(db.Enum('Family', 'Spouse', 'Friend', 'Colleague', 'Other', name='relationship_type_enum'))
    details = db.Column(db.Text)
    confidence_score = db.Column(db.Integer, default=100)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id1'], ['persons.person_id'], name='fk_person_relationships_person_id1', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['person_id2'], ['persons.person_id'], name='fk_person_relationships_person_id2', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_person_relationships_source_id'),
        db.UniqueConstraint('person_id1', 'person_id2', name='uq_person_relationship'),
    )