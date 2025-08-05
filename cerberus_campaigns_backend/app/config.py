import os
from dotenv import load_dotenv

project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
dotenv_path = os.path.join(project_root, '.env')

if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)
else:
    dotenv_path_repo_root = os.path.join(project_root, '..', '.env')
    if os.path.exists(dotenv_path_repo_root):
        load_dotenv(dotenv_path_repo_root)

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
    _db_url = os.environ.get('DATABASE_URL')
    if _db_url:
        if _db_url.startswith('postgresql+psycopg2://'):
            SQLALCHEMY_DATABASE_URI = _db_url.replace('postgresql+psycopg2://', 'postgresql+psycopg://', 1)
        elif _db_url.startswith('postgresql://'):
            SQLALCHEMY_DATABASE_URI = _db_url.replace('postgresql://', 'postgresql+psycopg://', 1)
        else:
            SQLALCHEMY_DATABASE_URI = _db_url
    else:
        SQLALCHEMY_DATABASE_URI = None

    if SQLALCHEMY_DATABASE_URI is None and not os.environ.get('FLASK_TESTING_SKIP_DB_CHECK'):
        raise ValueError("No DATABASE_URL set for production environment and not skipping DB check.")

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
