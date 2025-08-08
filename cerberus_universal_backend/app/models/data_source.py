from ..extensions import db

class DataSource(db.Model):
    __tablename__ = 'data_sources'

    source_id = db.Column(db.Integer, primary_key=True)
    source_name = db.Column(db.String(255))
    source_type = db.Column(db.Enum('Manual', 'API', 'Import', name='source_type_enum'), default='Manual')
    api_endpoint = db.Column(db.String(255))
    import_date = db.Column(db.Date)
    description = db.Column(db.String)
    data_retention_period = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())