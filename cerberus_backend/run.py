import os
from dotenv import load_dotenv

# Load .env file from the cerberus_backend directory (where run.py is located)
# This ensures that FLASK_APP, FLASK_ENV, and DATABASE_URL are set early.
dotenv_path = os.path.join(os.path.dirname(__file__), '.env') # .env in the same directory as run.py
if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)
    # print(f"Loaded environment variables from: {dotenv_path}") # For debugging
else:
    # Fallback: try to load .env from one directory above (e.g. if run.py is in a src/ subdir and .env is in root)
    # This is not the current structure, but good for robustness if structure changes.
    dotenv_path_parent = os.path.join(os.path.dirname(__file__), '..', '.env')
    if os.path.exists(dotenv_path_parent):
        load_dotenv(dotenv_path_parent)
        # print(f"Loaded environment variables from: {dotenv_path_parent}") # For debugging
    # else:
        # print(f"Warning: .env file not found at {dotenv_path} or {dotenv_path_parent}. Using system environment variables or defaults.")


# Now that .env is potentially loaded, we can import create_app
# which itself might depend on FLASK_ENV.
from app import create_app # 'app' is the package 'cerberus_backend/app'

# Determine the configuration name from FLASK_ENV, default to 'development'
# create_app will use this, or it can be passed explicitly.
# The FLASK_APP environment variable should be set to 'run.py' (or 'run:app' for Flask CLI)
# The FLASK_ENV environment variable should be 'development', 'production', or 'testing'.
flask_env = os.getenv('FLASK_ENV', 'development')
app = create_app(config_name_override=flask_env)

if __name__ == '__main__':
    # Use Gunicorn for production, Flask's built-in server for development/debugging.
    # The host '0.0.0.0' makes the server accessible externally (e.g., within Docker or LAN).
    # Debug mode should be enabled based on FLASK_ENV or app.config['DEBUG'].
    # Port can be configured via environment variable or defaulted.
    port = int(os.environ.get('PORT', 5001)) # Using 5001 to avoid conflict with other services

    is_debug_mode = app.config.get('DEBUG', False) # Get DEBUG from the app's config object

    # Note: For production, it's recommended to run via a WSGI server like Gunicorn directly,
    # e.g., `gunicorn --bind 0.0.0.0:5001 "run:app"`
    # This __main__ block is primarily for local development convenience.
    if flask_env == 'production':
        # print(f"Running in production mode. It is recommended to use Gunicorn or another WSGI server directly.")
        # Even in "production" mode via `python run.py`, use Flask's dev server but without debug.
        # For true production, Gunicorn should be the entry point.
        app.run(host='0.0.0.0', port=port, debug=False)
    else: # Development or other modes (e.g., testing, though typically tests run differently)
        # print(f"Running in '{flask_env}' mode with debug={'True' if is_debug_mode else 'False'}.")
        app.run(host='0.0.0.0', port=port, debug=is_debug_mode)
