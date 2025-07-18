from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_bcrypt import Bcrypt
from flask_cors import CORS

db = SQLAlchemy()
migrate = Migrate()
bcrypt = Bcrypt()
cors = CORS()

def init_extensions(app):
    """
    Initialize Flask extensions.
    """
    db.init_app(app)
    migrate.init_app(app, db)
    bcrypt.init_app(app)
    # Initialize CORS for all /api/* routes, allowing credentials
    cors.init_app(app, resources={r"/api/*": {"origins": "*"}}, supports_credentials=True)

    with app.app_context():
        from . import models  # noqa: F401 - Ensures models are registered with SQLAlchemy
        pass