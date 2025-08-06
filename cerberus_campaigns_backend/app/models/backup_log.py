from ..extensions import db

class BackupLog(db.Model):
    __tablename__ = 'backup_logs'

    backup_id = db.Column(db.Integer, primary_key=True)
    backup_type = db.Column(db.Enum('Full', 'Incremental', 'WAL', name='backup_type_enum'))
    backup_location = db.Column(db.String(255))
    backup_size = db.Column(db.BigInteger)
    backup_date = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    status = db.Column(db.Enum('Success', 'Failed', name='status_enum'), default='Success')
    retention_expiry_date = db.Column(db.Date)
    encryption_status = db.Column(db.Boolean, default=False)