import os
from dotenv import load_dotenv

# Load .env file from the directory where run.py is located.
dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)

# Import the app factory after loading environment variables.
from app import create_app

# Determine the configuration name from FLASK_ENV, defaulting to 'development'.
flask_env = os.getenv('FLASK_ENV', 'development')
app = create_app(config_name_override=flask_env)

if __name__ == '__main__':
    """
    This block is for local development convenience.
    For production, a WSGI server like Gunicorn should be used as the entry point.
    The Dockerfile CMD instruction handles this for deployment.
    """
    port = int(os.environ.get('PORT', 5001))
    is_debug_mode = app.config.get('DEBUG', False)

    print(f"Starting server in '{flask_env}' mode...")
    app.run(host='0.0.0.0', port=port, debug=is_debug_mode)