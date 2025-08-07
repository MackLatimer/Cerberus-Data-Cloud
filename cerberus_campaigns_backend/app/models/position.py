from ..extensions import db

class Position(db.Model):
    __tablename__ = 'positions'

    position_id = db.Column(db.Integer, primary_key=True)
    body_id = db.Column(db.Integer, nullable=False)
    position_title = db.Column(db.String(255))
    term_length = db.Column(db.Integer)
    salary = db.Column(db.DECIMAL(10,2))
    requirements = db.Column(db.Text)
    current_holder_person_id = db.Column(db.Integer)
    user_id = db.Column(db.Integer, nullable=True)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['body_id'], ['government_bodies.body_id'], name='fk_positions_body_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['current_holder_person_id'], ['persons.person_id'], name='fk_positions_current_holder_person_id'),
        db.ForeignKeyConstraint(['user_id'], ['users.user_id'], name='fk_positions_user_id'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_positions_source_id'),
    )