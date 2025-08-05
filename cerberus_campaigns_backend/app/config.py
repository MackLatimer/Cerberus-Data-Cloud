import os
from dotenv import load_dotenv
from google.cloud.sql.connector import Connector, IPTypes

project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
dotenv_path = os.path.join(project_root, '.env')

if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)
else:
    dotenv_path_repo_root = os.path.join(project_root, '..', '.env')
    if os.path.exists(dotenv_path_repo_root):
        load_dotenv(dotenv_path_repo_root)

def get_db_connection():
    connector = Connector()
    connection = connector.connect(
        os.environ["DB_CONNECTION_NAME"], # e.g. 'project:region:instance'
        "psycopg2",
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASS"],
        db=os.environ["DB_NAME"],
        ip_type=IPTypes.PRIVATE if os.environ.get("PRIVATE_IP") else IPTypes.PUBLIC
    )
    return connection

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'default_fallback_secret_key_please_change')
    STRIPE_SECRET_KEY = os.environ.get('STRIPE_SECRET_KEY')
    STRIPE_WEBHOOK_SECRET = os.environ.get('STRIPE_WEBHOOK_SECRET')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    DEBUG = False
    TESTING = False

class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', f"sqlite:///{os.path.join(project_root, 'dev.db')}")

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_ECHO = False

    _test_db_url = os.environ.get('TEST_DATABASE_URL')
    if not _test_db_url:
        SQLALCHEMY_DATABASE_URI = "sqlite:///:memory:"
    else:
        SQLALCHEMY_DATABASE_URI = _test_db_url

    SECRET_KEY = 'test_secret_key_for_flask_testing'

class ProductionConfig(Config):
    DEBUG = False
    SQLALCHEMY_DATABASE_URI = "postgresql+psycopg2://"
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
    return config_by_name.get(config_name_str, DevelopmentConfig)

current_config_name = os.environ.get('FLASK_ENV', 'development')
current_config = get_config_by_name(current_config_name)
