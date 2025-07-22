import sys
import os
import pytest

# Add the project root to the Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app
from app.extensions import db as _db

@pytest.fixture(scope='session')
def app():
    """Create and configure a new app instance for each test session."""
    app = create_app('app.config.TestingConfig')
    app_context = app.app_context()
    app_context.push()

    yield app

    app_context.pop()

@pytest.fixture(scope='function')
def client(app):
    return app.test_client()

@pytest.fixture(scope='session')
def db(app):
    """Session-wide test database."""
    _db.app = app
    _db.create_all()

    yield _db

    _db.drop_all()

@pytest.fixture(scope='function')
def session(db):
    """Creates a new database session for a test."""
    connection = db.engine.connect()
    transaction = connection.begin()

    session = db.Session(bind=connection)
    db.session = session

    yield session

    session.close()
    transaction.rollback()
    connection.close()
