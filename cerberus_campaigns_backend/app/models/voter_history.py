from ..extensions import db
from sqlalchemy.dialects.postgresql import JSONB

class VoterHistory(db.Model):
    __tablename__ = 'voter_history'

    history_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, db.ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    election_date = db.Column(db.Date)
    election_type = db.Column(db.String(100))
    voted = db.Column(db.Boolean)
    voting_method = db.Column(db.Enum('InPerson', 'Mail', 'Absentee', 'Other', name='voting_method_enum'))
    turnout_reason = db.Column(db.String)
    survey_link_id = db.Column(db.Integer, db.ForeignKey('survey_results.survey_id'))
    details = db.Column(JSONB)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())