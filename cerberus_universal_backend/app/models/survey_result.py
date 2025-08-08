from ..extensions import db
from sqlalchemy.dialects.postgresql import TSVECTOR

class SurveyResult(db.Model):
    __tablename__ = 'survey_results'

    survey_id = db.Column(db.Integer, primary_key=True)
    voter_id = db.Column(db.Integer, nullable=False)
    interaction_id = db.Column(db.Integer, nullable=True)
    survey_date = db.Column(db.Date)
    survey_source = db.Column(db.String(255))
    responses = db.Column(db.JSON)
    search_vector = db.Column(TSVECTOR) # This will be populated by a trigger
    confidence_score = db.Column(db.Integer, default=100)
    response_time = db.Column(db.Integer)
    survey_channel = db.Column(db.Enum('Online', 'Phone', 'InPerson', 'Mail', name='survey_channel_enum'))
    completion_status = db.Column(db.Enum('Complete', 'Partial', 'Abandoned', name='completion_status_enum'), default='Complete')
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    voter = db.relationship('Voter', back_populates='survey_responses')
    interaction = db.relationship('Interaction', back_populates='survey_responses')

    __table_args__ = (
        db.ForeignKeyConstraint(['voter_id'], ['voters.voter_id'], name='fk_survey_results_voter_id'),
        db.ForeignKeyConstraint(['interaction_id'], ['interactions.interaction_id'], name='fk_survey_results_interaction_id'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_survey_results_source_id'),
    )
