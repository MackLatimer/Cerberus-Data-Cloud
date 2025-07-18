import os
from dotenv import load_dotenv

# Correctly locate the .env file relative to the `cerberus_backend` directory
# __file__ is cerberus_backend/app/config.py
# basedir is cerberus_backend/app
# We want to go up two levels to find the .env file if it's at `cerberus_backend/.env`
# or one level up if the `run.py` and `.env` are in `cerberus_backend/`
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..')) # This is cerberus_backend/
dotenv_path = os.path.join(project_root, '.env')

if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)
else:
    # Attempt to load if .env is one level higher (e.g. repository root)
    # This might be less common for this specific structure but provides a fallback
    dotenv_path_repo_root = os.path.join(project_root, '..', '.env')
    if os.path.exists(dotenv_path_repo_root):
        load_dotenv(dotenv_path_repo_root)

class Config:
    """Base configuration."""
    SECRET_KEY = os.environ.get('SECRET_KEY', 'default_fallback_secret_key_please_change')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    DEBUG = False
    TESTING = False

    # JWT Configuration (optional)
    # JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY', 'default_jwt_secret_key')
    # JWT_ALGORITHM = os.environ.get('JWT_ALGORITHM', 'HS256')
    # ACCESS_TOKEN_EXPIRE_MINUTES = int(os.environ.get('ACCESS_TOKEN_EXPIRE_MINUTES', 30))
    # REFRESH_TOKEN_EXPIRE_DAYS = int(os.environ.get('REFRESH_TOKEN_EXPIRE_DAYS', 7))


class DevelopmentConfig(Config):
    """Development configuration."""
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', f"sqlite:///{os.path.join(project_root, 'dev.db')}")
    # For local development, ensure the Cloud SQL proxy is running if connecting to Cloud SQL
    # Or use a local PostgreSQL instance:
    # SQLALCHEMY_DATABASE_URI = "postgresql://campaign_user:local_password@localhost:5432/campaign_data"


class TestingConfig(Config):
    """Testing configuration."""
    TESTING = True
    SQLALCHEMY_ECHO = False # Keep test output clean

    # Prefer TEST_DATABASE_URL for a dedicated test DB (e.g., PostgreSQL)
    # Fallback to in-memory SQLite for simplicity if TEST_DATABASE_URL is not set.
    # Using in-memory SQLite is faster but may not support all PostgreSQL-specific features (e.g., JSONB ops).
    _test_db_url = os.environ.get('TEST_DATABASE_URL')
    if not _test_db_url:
        # print("WARNING: TEST_DATABASE_URL not set. Falling back to in-memory SQLite for tests. "
        #       "PostgreSQL-specific features (like JSONB) may not be fully tested.")
        SQLALCHEMY_DATABASE_URI = "sqlite:///:memory:"
    else:
        SQLALCHEMY_DATABASE_URI = _test_db_url

    SECRET_KEY = 'test_secret_key_for_flask_testing' # Consistent secret key for testing
    # Add any other test-specific configurations, e.g., disabling CSRF, rate limits for tests.
    # WTF_CSRF_ENABLED = False


class ProductionConfig(Config):
    """Production configuration."""
    DEBUG = False
    # Ensure DATABASE_URL is correctly set in the production environment
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')
    if SQLALCHEMY_DATABASE_URI is None and not os.environ.get('FLASK_TESTING_SKIP_DB_CHECK'): # Added for flexibility during build
        raise ValueError("No DATABASE_URL set for production environment and not skipping DB check.")

    # Ensure a real secret key is set for production
    if Config.SECRET_KEY == 'default_fallback_secret_key_please_change':
        raise ValueError("SECRET_KEY is not set for production environment.")

    # Security enhancements for production
    # SESSION_COOKIE_SECURE = True
    # REMEMBER_COOKIE_SECURE = True
    # SESSION_COOKIE_HTTPONLY = True
    # REMEMBER_COOKIE_HTTPONLY = True


config_by_name = dict(
    development=DevelopmentConfig,
    testing=TestingConfig,
    production=ProductionConfig,
    default=DevelopmentConfig
)

def get_config_by_name(config_name_str: str) -> Config:
    """Returns the configuration object based on the FLASK_ENV environment variable."""
    return config_by_name.get(config_name_str, DevelopmentConfig)

# Helper to get current config easily
current_config_name = os.environ.get('FLASK_ENV', 'development')
current_config = get_config_by_name(current_config_name)
