from ..extensions import db

class GovernmentBody(db.Model):
    __tablename__ = 'government_bodies'

    body_id = db.Column(db.Integer, primary_key=True)
    body_name = db.Column(db.String(255))
    jurisdiction = db.Column(db.String(100))
    details = db.Column(db.JSON)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_government_bodies_source_id'),
    )