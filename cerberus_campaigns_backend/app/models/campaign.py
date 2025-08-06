from ..extensions import db

class Campaign(db.Model):
    __tablename__ = 'campaigns'

    campaign_id = db.Column(db.Integer, primary_key=True)
    campaign_name = db.Column(db.String(255))
    start_date = db.Column(db.Date)
    end_date = db.Column(db.Date)
    campaign_type = db.Column(db.Enum('Local', 'State', 'Federal', 'Issue', name='campaign_type_enum'))
    details = db.Column(db.JSON)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id', use_alter=True))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())