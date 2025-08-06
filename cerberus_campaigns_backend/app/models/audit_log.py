from ..extensions import db

class AuditLog(db.Model):
    __tablename__ = 'audit_logs'

    log_id = db.Column(db.Integer, primary_key=True)
    table_name = db.Column(db.String(100))
    record_id = db.Column(db.Integer)
    action_type = db.Column(db.Enum('INSERT', 'UPDATE', 'DELETE', name='action_type_enum'))
    changed_by_user = db.Column(db.String(255))
    ip_address = db.Column(db.String(45))
    session_id = db.Column(db.String(100))
    changes = db.Column(db.JSON)
    timestamp = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())