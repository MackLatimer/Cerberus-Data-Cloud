import os
from google.cloud.sql.connector import Connector, IPTypes
from google.cloud import secretmanager

def access_secret_version(secret_id, version_id="latest"):
    """Access the payload for the given secret version."""
    client = secretmanager.SecretManagerServiceClient()
    project_id = os.environ.get("GCP_PROJECT")
    name = f"projects/{project_id}/secrets/{secret_id}/versions/{version_id}"
    response = client.access_secret_version(name=name)
    return response.payload.data.decode('UTF-8')

# According to 12-Factor App methodology, configuration should be stored in the environment.
# For production environments, it is highly recommended to use a secret management service
# like Google Secret Manager to securely store and manage sensitive information.
# The application will fail to start if these required environment variables are not set.
# This is intentional and prevents running with an insecure or incomplete configuration.
try:
    # For production, these variables should be sourced from Secret Manager.
    DB_USER = os.environ.get("DB_USER") or access_secret_version("DB_USER")
    DB_PASS = os.environ.get("DB_PASS") or access_secret_version("DB_PASS")
    DB_NAME = os.environ.get("DB_NAME") or access_secret_version("DB_NAME")
    DB_CONNECTION_NAME = os.environ.get("DB_CONNECTION_NAME") or access_secret_version("DB_CONNECTION_NAME")
    SECRET_KEY = os.environ.get("SECRET_KEY") or access_secret_version("SECRET_KEY")
    PGCRYPTO_SECRET_KEY = os.environ.get("PGCRYPTO_SECRET_KEY") or access_secret_version("PGCRYPTO_SECRET_KEY")
    STRIPE_SECRET_KEY = os.environ.get("STRIPE_SECRET_KEY") or access_secret_version("STRIPE_SECRET_KEY")
    STRIPE_WEBHOOK_SECRET = os.environ.get("STRIPE_WEBHOOK_SECRET") or access_secret_version("STRIPE_WEBHOOK_SECRET")
    WEBHOOK_SECRET_KEY = os.environ.get("WEBHOOK_SECRET_KEY") or access_secret_version("WEBHOOK_SECRET_KEY")
except KeyError as e:
    raise RuntimeError(f"Missing required environment variable: {e}") from e

# PRIVATE_IP is optional for configuring private IP database connections.
PRIVATE_IP = os.environ.get("PRIVATE_IP")

def get_db_connection():
    """Initializes a connection pool for a Cloud SQL instance."""
    connector = Connector()
    connection = connector.connect(
        DB_CONNECTION_NAME,
        "psycopg",
        user=DB_USER,
        password=DB_PASS,
        db=DB_NAME,
        ip_type=IPTypes.PRIVATE if PRIVATE_IP else IPTypes.PUBLIC
    )
    return connection

class Config:
    """Base configuration."""
    SECRET_KEY = SECRET_KEY
    STRIPE_SECRET_KEY = STRIPE_SECRET_KEY
    STRIPE_WEBHOOK_SECRET = STRIPE_WEBHOOK_SECRET
    PGCRYPTO_SECRET_KEY = PGCRYPTO_SECRET_KEY
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    DEBUG = False
    TESTING = False

class DevelopmentConfig(Config):
    """Development configuration."""
    DEBUG = True
    # For local development, set the DATABASE_URL environment variable.
    # Example: postgresql+psycopg://user:password@localhost:5432/voter_db
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')

class TestingConfig(Config):
    """Testing configuration."""
    TESTING = True
    SQLALCHEMY_ECHO = False
    # Use a separate test database or an in-memory SQLite database for tests.
    # Example: DATABASE_URL="postgresql+psycopg://test_user:test_password@localhost:5432/test_db"
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'DATABASE_URL',
        'sqlite:///:memory:' # Default to in-memory SQLite for simple tests
    )
    SECRET_KEY = os.environ.get("TEST_SECRET_KEY", 'test_secret_key_for_flask_testing')

class ProductionConfig(Config):
    """Production configuration."""
    # In production, the database connection is managed by the Cloud SQL Python Connector.
    # The SQLAlchemy engine is configured with a "creator" function that establishes
    # a secure connection to the Cloud SQL instance.
    SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg://'
    SQLALCHEMY_ENGINE_OPTIONS = {
        "creator": get_db_connection,
        "pool_size": 5,
        "max_overflow": 2,
        "pool_timeout": 30,
        "pool_recycle": 1800,
    }

config_by_name = dict(
    development=DevelopmentConfig,
    testing=TestingConfig,
    production=ProductionConfig,
    default=DevelopmentConfig
)

def get_config_by_name(config_name_str: str) -> Config:
    """Gets the configuration class based on the given name."""
    return config_by_name.get(config_name_str, DevelopmentConfig)

# Determine the active configuration
current_config_name = os.environ.get('FLASK_ENV', 'development')
current_config = get_config_by_name(current_config_name)
