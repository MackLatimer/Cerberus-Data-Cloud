import pytest
import os

os.environ['FLASK_ENV'] = 'testing'

from app import create_app
from app.extensions import db as _db
from sqlalchemy import text

# Import all models to ensure they are registered with SQLAlchemy
from app.models import (
    DataSource, Person, PartyAffiliationHistory, PersonIdentifier, Address,
    PersonAddress, PersonEmail, PersonPhone, PersonSocialMedia, PersonEmployer,
    PersonPaymentInfo, PersonOtherContact, VoterHistory, SurveyResult,
    PersonRelationship, District, AddressDistrict, Campaign,
    PersonCampaignInteraction, GovernmentBody, Position, Donation,
    PersonMerge, AuditLog, BackupLog, User
)

@pytest.fixture(scope='session')
def app():
    _app = create_app()
    yield _app

@pytest.fixture(scope='function')
def client(app):
    with app.app_context():
        with app.test_client() as client:
            yield client

@pytest.fixture(scope='session')
def db(app):
    """
    Session-scoped database fixture. Assumes the database schema is already created.
    """
    with app.app_context():
        yield _db

@pytest.fixture(scope='function')
def session(app, db):
    with app.app_context():
        connection = _db.engine.connect()
        transaction = connection.begin()
        test_db_session = _db.Session(bind=connection)
        try:
            yield test_db_session
        finally:
            transaction.rollback()
            test_db_session.close()
            connection.close()

@pytest.fixture(scope='function')
def setup_data_source(session):
    # Ensure a default data source exists for tests
    data_source = session.query(DataSource).get(1)
    if not data_source:
        data_source = DataSource(source_id=1, source_name="Test Source", source_type="Manual")
        session.add(data_source)
        session.commit()
    return data_source

@pytest.fixture
def skip_if_sqlite(session):
    if 'sqlite' in session.bind.engine.dialect.name:
        pytest.skip("Test does not run on SQLite")

def pytest_collection_modifyitems(config, items):
    # This function is kept for historical purposes, but skip_if_sqlite fixture is preferred
    pass
