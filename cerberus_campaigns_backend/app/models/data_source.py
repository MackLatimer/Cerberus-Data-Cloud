from sqlalchemy import Column, Integer, String, Date, TIMESTAMP, Enum
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class DataSource(Base):
    __tablename__ = 'data_sources'

    source_id = Column(Integer, primary_key=True)
    source_name = Column(String(255))
    source_type = Column(Enum('Manual', 'API', 'Import', name='source_type_enum'), default='Manual')
    api_endpoint = Column(String(255))
    import_date = Column(Date)
    description = Column(String)
    data_retention_period = Column(Integer)
    created_at = Column(TIMESTAMP, default=func.current_timestamp())