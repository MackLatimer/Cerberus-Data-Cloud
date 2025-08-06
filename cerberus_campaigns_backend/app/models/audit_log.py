from sqlalchemy import Column, Integer, String, TIMESTAMP, Enum
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import JSONB

Base = declarative_base()

class AuditLog(Base):
    __tablename__ = 'audit_logs'

    log_id = Column(Integer, primary_key=True)
    table_name = Column(String(100))
    record_id = Column(Integer)
    action_type = Column(Enum('INSERT', 'UPDATE', 'DELETE', name='action_type_enum'))
    changed_by_user = Column(String(255))
    ip_address = Column(String(45))
    session_id = Column(String(100))
    changes = Column(JSONB)
    timestamp = Column(TIMESTAMP, default=func.current_timestamp())