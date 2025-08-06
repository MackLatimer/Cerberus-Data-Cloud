from ..extensions import db

class PersonMerge(db.Model):
    __tablename__ = 'person_merges'

    merge_id = db.Column(db.Integer, primary_key=True)
    merged_from_person_id = db.Column(db.Integer, db.ForeignKey('persons.person_id'), nullable=False)
    merged_to_person_id = db.Column(db.Integer, db.ForeignKey('persons.person_id'), nullable=False)
    merge_date = db.Column(db.Date, default=db.func.current_date())
    merge_reason = db.Column(db.String)
    merge_confidence = db.Column(db.Integer)
    merge_method = db.Column(db.Enum('Manual', 'Automated', name='merge_method_enum'), default='Manual')
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())