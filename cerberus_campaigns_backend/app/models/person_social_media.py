from ..extensions import db

class PersonSocialMedia(db.Model):
    __tablename__ = 'person_social_media'

    social_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    platform = db.Column(db.String(50))
    handle = db.Column(db.String(255), unique=True)
    confidence_score = db.Column(db.Integer, default=100)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_person_social_media_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_person_social_media_source_id'),
    )