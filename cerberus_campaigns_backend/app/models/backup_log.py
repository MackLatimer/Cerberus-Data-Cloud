from sqlalchemy import Column, Integer, String, BigInteger, Date, TIMESTAMP, Enum
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class BackupLog(Base):
    __tablename__ = 'backup_logs'

    backup_id = Column(Integer, primary_key=True)
    backup_type = Column(Enum('Full', 'Incremental', 'WAL', name='backup_type_enum'))
    backup_location = Column(String(255))
    backup_size = Column(BigInteger)
    backup_date = Column(TIMESTAMP, default=func.current_timestamp())
    status = Column(Enum('Success', 'Failed', name='status_enum'), default='Success')
    retention_expiry_date = Column(Date)
    encryption_status = Column(Boolean, default=False)