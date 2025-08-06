import pytest
import os

os.environ['FLASK_ENV'] = 'testing'
os.environ['FLASK_TESTING_SKIP_DB_CHECK'] = 'True'

from app import create_app
from app.extensions import db as _db

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
    with app.app_context():
        if "sqlite:///:memory:" not in app.config['SQLALCHEMY_DATABASE_URI'] and not app.config.get("SQLALCHEMY_DATABASE_URI", "").startswith("sqlite://"):
            _db.drop_all()
        _db.create_all()
        yield _db
        _db.session.remove()
        if "sqlite:///:memory:" not in app.config['SQLALCHEMY_DATABASE_URI'] and not app.config.get("SQLALCHEMY_DATABASE_URI", "").startswith("sqlite://"):
            _db.drop_all()

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
def skip_if_sqlite(app):
    with app.app_context():
        if app.config.get('SQLALCHEMY_DATABASE_URI', '').startswith('sqlite://'):
            pytest.skip("Skipping test on SQLite database.")