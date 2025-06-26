from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_bcrypt import Bcrypt
from flask_cors import CORS # Import CORS

db = SQLAlchemy()
migrate = Migrate()
bcrypt = Bcrypt()
cors = CORS() # Initialize CORS

# If you add other extensions, initialize them here
# e.g., from flask_mail import Mail
# mail = Mail()

def init_extensions(app):
    """
    Initialize Flask extensions.
    """
    db.init_app(app)
    migrate.init_app(app, db) # Initialize Flask-Migrate
    bcrypt.init_app(app)
    cors.init_app(app, resources={r"/api/*": {"origins": "*"}}) # Initialize CORS for all /api/* routes
    # mail.init_app(app) # if using Flask-Mail

    # For Flask-Migrate, it's good practice to ensure models are imported
    # before the first request if they are not already imported elsewhere
    # when the app context is available.
    # This is crucial for Alembic to detect model changes for migrations.
    # Typically, you'd import your models module or individual models.
    with app.app_context():
        from . import models # noqa: F401 - This ensures models are registered with SQLAlchemy
        pass
