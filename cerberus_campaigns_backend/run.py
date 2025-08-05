from dotenv import load_dotenv
import os

# Determine the path to the .env file. 
# This assumes the .env file is in the same directory as run.py
dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)

from app import create_app

app = create_app()

if __name__ == '__main__':
    # The app.run() command is only for local development 
    # and will not be used when deploying with Gunicorn.
    # Gunicorn will directly interact with the `app` object.
    app.run()