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

from sqlalchemy import event
from sqlalchemy.engine import Engine


@pytest.fixture(scope='session')
def app():
    @event.listens_for(Engine, "connect")
    def load_spatialite(dbapi_conn, connection_record):
        import sqlite3
        if isinstance(dbapi_conn, sqlite3.Connection):
            dbapi_conn.enable_load_extension(True)
            try:
                dbapi_conn.load_extension('mod_spatialite')
            except sqlite3.OperationalError:
                # Handle case where the extension is not found or fails to load
                print("SpatiaLite extension not found, skipping spatial tests.")

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
    """
    Creates a new database session for a test. This is the recommended
    setup for testing with a real database.
    """
    with app.app_context():
        # All tests will have a clean database
        db.drop_all()
        db.create_all()
        yield db.session

@pytest.fixture(scope='function')
def setup_data_source(session):
    # Ensure a default data source exists for tests
    data_source = session.query(DataSource).get(1)
    if not data_source:
        data_source = DataSource(source_id=1, source_name="Test Source", source_type="Manual")
        session.add(data_source)
        session.commit()
    return data_source


def pytest_collection_modifyitems(config, items):
    # This function is kept for historical purposes, but skip_if_sqlite fixture is preferred
    pass


@pytest.fixture(scope='function')
def authenticated_client(client, session):
    """Provides a test client that is authenticated with a test user."""
    from app.models import User

    # 1. Create user
    test_user = User(username='testuser', password='testpassword', role='Admin')
    session.add(test_user)
    session.commit()

    # 2. Login to get token
    login_data = {'username': 'testuser', 'password': 'testpassword'}
    response = client.post('/api/v1/auth/login', json=login_data)
    assert response.status_code == 200, "Failed to log in with test user"
    token = response.get_json()['token']

    # 3. Set header for subsequent requests
    client.environ_base['HTTP_AUTHORIZATION'] = f'Bearer {token}'

    yield client

    # 4. Clean up
    client.environ_base.pop('HTTP_AUTHORIZATION', None)
