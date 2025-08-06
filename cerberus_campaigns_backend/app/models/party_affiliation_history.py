from ..extensions import db

class PartyAffiliationHistory(db.Model):
    __tablename__ = 'party_affiliation_history'

    history_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, db.ForeignKey('persons.person_id', ondelete='CASCADE'), nullable=False)
    party_affiliation = db.Column(db.String(100))
    valid_from = db.Column(db.Date, nullable=False)
    valid_to = db.Column(db.Date)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())