import os
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

    # For production, you should restrict this to your frontend's domain(s).
    # This can be set via an environment variable.
    if app.config.get('ENV') == 'production' or os.environ.get('FLASK_ENV') == 'production':
        # Read allowed origins from an environment variable (e.g., 'https://domain1.com,https://domain2.com')
        allowed_origins_str = os.environ.get('CORS_ORIGINS')
        if allowed_origins_str:
            origins = [origin.strip() for origin in allowed_origins_str.split(',')]
            app.logger.info(f"CORS enabled for production origins: {origins}")
        else:
            # Log a critical warning if not set in production.
            app.logger.warning("CORS_ORIGINS environment variable is not set in production. API will not be accessible from frontends.")
            origins = [] # Effectively disables cross-origin requests
    else:
        # For development, allow all origins.
        origins = "*"

    cors.init_app(app, resources={r"/api/*": {"origins": origins}}, supports_credentials=True)

    with app.app_context():
        from . import models  # noqa: F401 - Ensures models are registered with SQLAlchemy
        pass