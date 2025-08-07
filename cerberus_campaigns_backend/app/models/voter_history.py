from ..extensions import db
from sqlalchemy.dialects.postgresql import JSONB

class VoterHistory(db.Model):
    __tablename__ = 'voter_history'

    history_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    election_date = db.Column(db.Date)
    election_type = db.Column(db.String(100))
    voted = db.Column(db.Boolean)
    voting_method = db.Column(db.Enum('InPerson', 'Mail', 'Absentee', 'Other', name='voting_method_enum'))
    turnout_reason = db.Column(db.String)
    survey_link_id = db.Column(db.Integer)
    details = db.Column(JSONB)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_voter_history_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['survey_link_id'], ['survey_results.survey_id'], name='fk_voter_history_survey_link_id'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_voter_history_source_id'),
    )