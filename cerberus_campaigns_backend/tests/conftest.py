import pytest
import os
import jwt
from datetime import datetime, timedelta, timezone

os.environ['FLASK_ENV'] = 'testing'
os.environ['FLASK_TESTING_SKIP_DB_CHECK'] = 'True'

from app import create_app
from app.extensions import db as _db
from app.models.user import User

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
def test_user(session):
    """Fixture to create a test user."""
    user = User(username='testuser', password='password', email='test@user.com')
    session.add(user)
    session.commit()
    return user

@pytest.fixture(scope='function')
def auth_token(app, test_user):
    """Fixture to generate a JWT for the test user."""
    with app.app_context():
        token = jwt.encode({
            'user_id': test_user.user_id,
            'exp': datetime.now(timezone.utc) + timedelta(hours=1)
        }, app.config['SECRET_KEY'], algorithm="HS256")
        return token
