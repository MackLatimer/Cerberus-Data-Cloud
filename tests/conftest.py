import pytest
from app import create_app, db
from sqlalchemy import text, event
from sqlalchemy.engine import Engine

@pytest.fixture(scope='session')
def app():
    """
    Creates a new Flask application for a test session.
    """
    _app = create_app(testing=True)

    # Establish an application context before running the tests.
    ctx = _app.app_context()
    ctx.push()

    yield _app

    ctx.pop()


@pytest.fixture(scope='session')
def client(app):
    """
    Creates a test client for the Flask application.
    """
    return app.test_client()


@pytest.fixture(scope='function')
def session(app, db):
    """
    Creates a new database session for a test. This is the recommended
    setup for testing with a real database.
    """
    with app.app_context():
        # All tests will have a clean database
        with db.engine.connect() as connection:
            connection.execute(text("DROP MATERIALIZED VIEW IF EXISTS voter_turnout_summary CASCADE;"))
            connection.commit()
        db.drop_all()
        db.create_all()

        yield db.session

        db.session.remove()
        with db.engine.connect() as connection:
            connection.execute(text("DROP MATERIALIZED VIEW IF EXISTS voter_turnout_summary CASCADE;"))
            connection.commit()
        db.drop_all()
