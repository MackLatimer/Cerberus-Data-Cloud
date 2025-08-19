import os
from google.cloud.sql.connector import Connector, IPTypes
from google.cloud import secretmanager
import pg8000

import google.auth
from google.api_core import exceptions as google_exceptions

def access_secret_version(secret_id, version_id="latest"):
    """Access the payload for the given secret version."""
    try:
        client = secretmanager.SecretManagerServiceClient()
        credentials, project_id = google.auth.default()
        name = f"projects/{project_id}/secrets/{secret_id}/versions/{version_id}"
        response = client.access_secret_version(name=name)
        return response.payload.data.decode('UTF-8')
    except google_exceptions.PermissionDenied:
        raise RuntimeError(f"Permission denied for secret '{secret_id}' in project '{project_id}'. Please grant the 'Secret Manager Secret Accessor' role.")
    except google_exceptions.NotFound:
        raise RuntimeError(f"Secret '{secret_id}' not found in project '{project_id}'.")
    except Exception as e:
        raise RuntimeError(f"An unexpected error occurred while accessing secret '{secret_id}': {e}")

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
    SECRET_KEY = os.environ.get("FLASK_SECRET_KEY") or access_secret_version("FLASK_SECRET_KEY")
    PGCRYPTO_SECRET_KEY = os.environ.get("PGCRYPTO_SECRET_KEY") or access_secret_version("PGCRYPTO_SECRET_KEY")
    STRIPE_SECRET_KEYS = {
        'blair_frontend': os.environ.get("BLAIR_STRIPE_SECRET_KEY") or access_secret_version("BLAIR_STRIPE_SECRET_KEY"),
        'cox_frontend': os.environ.get("COX_STRIPE_SECRET_KEY") or access_secret_version("COX_STRIPE_SECRET_KEY"),
        'emmons_frontend': os.environ.get("EMMONS_STRIPE_SECRET_KEY") or access_secret_version("EMMONS_STRIPE_SECRET_KEY"),
        'gauntt_frontend': os.environ.get("GAUNTT_STRIPE_SECRET_KEY") or access_secret_version("GAUNTT_STRIPE_SECRET_KEY"),
        'mintz_frontend': os.environ.get("MINTZ_STRIPE_SECRET_KEY") or access_secret_version("MINTZ_STRIPE_SECRET_KEY"),
        'tice_frontend': os.environ.get("TICE_STRIPE_SECRET_KEY") or access_secret_version("TICE_STRIPE_SECRET_KEY"),
        'tulloch_frontend': os.environ.get("TULLOCH_STRIPE_SECRET_KEY") or access_secret_version("TULLOCH_STRIPE_SECRET_KEY"),
        'leudeke_frontend': os.environ.get("LEUDEKE_STRIPE_SECRET_KEY") or access_secret_version("LEUDEKE_STRIPE_SECRET_KEY"),
        'whitson_frontend': os.environ.get("WHITSON_STRIPE_SECRET_KEY") or access_secret_version("WHITSON_STRIPE_SECRET_KEY"),
    }
    STRIPE_WEBHOOK_KEYS = {
        'blair_frontend': os.environ.get("BLAIR_STRIPE_WEBHOOK_KEY") or access_secret_version("BLAIR_STRIPE_WEBHOOK_KEY"),
        'cox_frontend': os.environ.get("COX_STRIPE_WEBHOOK_KEY") or access_secret_version("COX_STRIPE_WEBHOOK_KEY"),
        'emmons_frontend': os.environ.get("EMMONS_STRIPE_WEBHOOK_KEY") or access_secret_version("EMMONS_STRIPE_WEBHOOK_KEY"),
        'gauntt_frontend': os.environ.get("GAUNTT_STRIPE_WEBHOOK_KEY") or access_secret_version("GAUNTT_STRIPE_WEBHOOK_KEY"),
        'mintz_frontend': os.environ.get("MINTZ_STRIPE_WEBHOOK_KEY") or access_secret_version("MINTZ_STRIPE_WEBHOOK_KEY"),
        'tice_frontend': os.environ.get("TICE_STRIPE_WEBHOOK_KEY") or access_secret_version("TICE_STRIPE_WEBHOOK_KEY"),
        # 'tulloch_frontend': os.environ.get("TULLOCH_STRIPE_WEBHOOK_KEY") or access_secret_version("TULLOCH_STRIPE_WEBHOOK_KEY"),
        'leudeke_frontend': os.environ.get("LEUDEKE_STRIPE_WEBHOOK_KEY") or access_secret_version("LEUDEKE_STRIPE_WEBHOOK_KEY"),
        'whitson_frontend': os.environ.get("WHITSON_STRIPE_WEBHOOK_KEY") or access_secret_version("WHITSON_STRIPE_WEBHOOK_KEY"),
    }
except KeyError as e:
    raise RuntimeError(f"Missing required environment variable: {e}") from e

# PRIVATE_IP is optional for configuring private IP database connections.
PRIVATE_IP = os.environ.get("PRIVATE_IP")

def get_db_connection():
    """Initializes a connection pool for a Cloud SQL instance."""
    connector = Connector()
    connection = connector.connect(
        DB_CONNECTION_NAME,
        "pg8000",
        user=DB_USER,
        password=DB_PASS,
        db=DB_NAME,
        ip_type=IPTypes.PRIVATE if PRIVATE_IP else IPTypes.PUBLIC
    )
    return connection

class Config:
    """Base configuration."""
    CORS_ORIGINS = [
        "https://electemmons.com",
        "https://beaforjp.com",
        "http://localhost:8080", # Example for local development
    ]

    SECRET_KEY = SECRET_KEY
    STRIPE_SECRET_KEYS = STRIPE_SECRET_KEYS
    STRIPE_WEBHOOK_KEYS = STRIPE_WEBHOOK_KEYS
    PGCRYPTO_SECRET_KEY = PGCRYPTO_SECRET_KEY
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    DEBUG = False
    TESTING = False

    CAMPAIGN_STRIPE_KEY_MAPPING = {
        1: 'blair_frontend',
        2: 'cox_frontend',
        3: 'emmons_frontend',
        4: 'gauntt_frontend',
        5: 'mintz_frontend',
        6: 'tice_frontend',
        7: 'tulloch_frontend',
        8: 'leudeke_frontend',
        9: 'whitson_frontend',
    }

class DevelopmentConfig(Config):
    """Development configuration."""
    DEBUG = True
    # For local development, set the DATABASE_URL environment variable.
    # Example: postgresql+pg8000://user:password@localhost:5432/voter_db
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')

class TestingConfig(Config):
    """Testing configuration."""
    TESTING = True
    SQLALCHEMY_ECHO = False
    # Use a separate test database or an in-memory SQLite database for tests.
    # Example: DATABASE_URL="postgresql+pg8000://test_user:test_password@localhost:5432/test_db"
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'DATABASE_URL',
        'sqlite:///:memory:' # Default to in-memory SQLite for simple tests
    )
    FLASK_SECRET_KEY = os.environ.get("TEST_SECRET_KEY", 'test_secret_key_for_flask_testing')

class ProductionConfig(Config):
    """Production configuration."""
    # In production, the database connection is managed by the Cloud SQL Python Connector.
    # The SQLAlchemy engine is configured with a "creator" function that establishes
    # a secure connection to the Cloud SQL instance.
    SQLALCHEMY_DATABASE_URI = 'postgresql+pg8000://user:password@localhost/dbname' # Changed from psycopg2
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
