from ..extensions import db

class PartyAffiliationHistory(db.Model):
    __tablename__ = 'party_affiliation_history'

    history_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    party_affiliation = db.Column(db.String(100))
    valid_from = db.Column(db.Date, nullable=False)
    valid_to = db.Column(db.Date)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_party_affiliation_history_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_party_affiliation_history_source_id'),
    )