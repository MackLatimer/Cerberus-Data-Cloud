import os
from google.cloud import secretmanager
from google.cloud.sql.connector import Connector, IPTypes

# Function to access secrets from Google Cloud Secret Manager
def access_secret_version(secret_id, project_id, version_id="latest"):
    """
    Access the payload for the given secret version and return it.
    """
    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()

    # Build the resource name of the secret version.
    name = f"projects/{project_id}/secrets/{secret_id}/versions/{version_id}"

    # Access the secret version.
    response = client.access_secret_version(request={"name": name})

    # Return the decoded payload.
    return response.payload.data.decode("UTF-8")

# It's recommended to set the GCP_PROJECT in your environment.
# If you're running on Google Cloud services like Cloud Run,
# the project ID can often be inferred from the environment.
PROJECT_ID = os.environ.get("GCP_PROJECT")

# --- Secret Fetching ---
# Initialize secrets to None. This is important for graceful fallback.
DB_CONNECTION_NAME = None
DB_USER = None
DB_PASS = None
DB_NAME = None
SECRET_KEY = None
STRIPE_SECRET_KEY = None
STRIPE_WEBHOOK_SECRET = None
PGCRYPTO_SECRET_KEY = None

# Attempt to fetch secrets from Secret Manager only if a PROJECT_ID is available.
if PROJECT_ID:
    try:
        DB_CONNECTION_NAME = access_secret_version("DB_CONNECTION_NAME", PROJECT_ID)
        DB_USER = access_secret_version("DB_USER", PROJECT_ID)
        DB_PASS = access_secret_version("DB_PASS", PROJECT_ID)
        DB_NAME = access_secret_version("DB_NAME", PROJECT_ID)
        SECRET_KEY = access_secret_version("SECRET_KEY", PROJECT_ID)
        STRIPE_SECRET_KEY = access_secret_version("STRIPE_SECRET_KEY", PROJECT_ID)
        STRIPE_WEBHOOK_SECRET = access_secret_version("STRIPE_WEBHOOK_SECRET", PROJECT_ID)
        PGCRYPTO_SECRET_KEY = access_secret_version("PGCRYPTO_SECRET_KEY", PROJECT_ID)
    except Exception as e:
        print(f"Warning: Could not fetch all secrets from Secret Manager. Error: {e}")
        print("Falling back to environment variables for missing secrets.")

# --- Fallback to Environment Variables ---
# Use the fetched secret, or fall back to an environment variable if the secret is still None.
DB_CONNECTION_NAME = DB_CONNECTION_NAME or os.environ.get("DB_CONNECTION_NAME")
DB_USER = DB_USER or os.environ.get("DB_USER")
DB_PASS = DB_PASS or os.environ.get("DB_PASS")
DB_NAME = DB_NAME or os.environ.get("DB_NAME")
SECRET_KEY = SECRET_KEY or os.environ.get('SECRET_KEY', 'default_fallback_secret_key_please_change')
STRIPE_SECRET_KEY = STRIPE_SECRET_KEY or os.environ.get('STRIPE_SECRET_KEY')
STRIPE_WEBHOOK_SECRET = STRIPE_WEBHOOK_SECRET or os.environ.get('STRIPE_WEBHOOK_SECRET')
PGCRYPTO_SECRET_KEY = PGCRYPTO_SECRET_KEY or os.environ.get('PGCRYPTO_SECRET_KEY', 'a_very_secret_key_for_encryption')
PRIVATE_IP = os.environ.get("PRIVATE_IP") # This can still be an environment variable

def get_db_connection():
    """Initializes a connection to the database."""
    if not all([DB_CONNECTION_NAME, DB_USER, DB_PASS, DB_NAME]):
        raise ValueError("Database connection details are not fully configured.")

    connector = Connector()
    connection = connector.connect(
        DB_CONNECTION_NAME,
        "psycopg2",
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
    # In development, you might use a local DB connection string
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', 'postgresql+psycopg2://user:password@localhost:5432/voter_db')

class TestingConfig(Config):
    """Testing configuration."""
    TESTING = True
    SQLALCHEMY_ECHO = False
    DB_USER = os.environ.get("DB_USER", "test_user")
    DB_PASS = os.environ.get("DB_PASS", "test_password")
    DB_HOST = os.environ.get("DB_HOST", "postgres-test-db")
    DB_PORT = os.environ.get("DB_PORT", "5432")
    DB_NAME = os.environ.get("DB_NAME", "test_db")
    SQLALCHEMY_DATABASE_URI = f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    SECRET_KEY = 'test_secret_key_for_flask_testing'

class ProductionConfig(Config):
    """Production configuration."""
    DEBUG = False
    # For Google Cloud SQL, the creator function handles the connection.
    SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg2://'
    SQLALCHEMY_ENGINE_OPTIONS = {
        "creator": get_db_connection
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
