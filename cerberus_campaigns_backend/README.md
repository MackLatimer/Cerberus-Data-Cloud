# Cerberus Campaigns Backend

## Overview

The Cerberus Campaigns Backend is a Python-based Flask application responsible for managing all campaign-related data. This includes voter information, campaign details, user interactions, survey responses, and user accounts. It serves as the central data store and API for various frontend applications within the Cerberus ecosystem.

## Key Features

*   **Voter Management**: Store and retrieve detailed voter profiles.
*   **Campaign Management**: Handle data for multiple campaigns.
*   **Interaction Tracking**: Log interactions with voters (e.g., calls, visits).
*   **Survey Management**: Store and manage survey questions and responses.
*   **User Authentication**: (Planned/To be verified) Manage user accounts and access control.
*   **API Endpoints**: Provides RESTful API endpoints for data manipulation and retrieval.

## Technology Stack

*   **Framework**: Flask
*   **Database**: PostgreSQL (intended, uses SQLite for local development by default)
*   **ORM**: SQLAlchemy
*   **Environment Management**: `python-dotenv`

## Connections

*   **`emmons_frontend`**: This Flutter-based campaign frontend connects to the Cerberus Campaigns Backend to fetch voter data, record interactions, and submit survey responses relevant to its specific campaign. The connection is typically configured in the frontend's settings (e.g., `emmons_frontend/lib/src/config.dart`).
*   **`cerberus_frontend` (Data Portal)**: The data portal section of the `cerberus_frontend` connects to this backend to allow for administrative tasks such as uploading voter lists, viewing comprehensive data across campaigns, and managing campaign settings.

## Project Structure

*   `app/`: Main application directory.
    *   `models/`: SQLAlchemy database models (e.g., `voter.py`, `campaign.py`).
    *   `routes/`: Flask blueprints defining API endpoints (e.g., `voters.py`).
    *   `services/`: Business logic and service layer components.
    *   `__init__.py`: Application factory.
    *   `config.py`: Configuration classes (Development, Testing, Production).
    *   `extensions.py`: Flask extension initializations (e.g., SQLAlchemy, Migrate).
*   `migrations/`: (If using Flask-Migrate) Database migration scripts.
*   `tests/`: Unit and integration tests.
*   `.env.example`: Example environment variable file.
*   `requirements.txt`: Python package dependencies.
*   `run.py`: Script to run the Flask development server.
*   `database_schema.sql`: (If available) SQL schema definition.

## Setup and Installation

1.  **Clone the repository (if you haven't already):**
    ```bash
    git clone <repository_url>
    cd <repository_directory>/cerberus_campaigns_backend
    ```

2.  **Create and activate a virtual environment:**
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate
    ```

3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Configure environment variables:**
    *   Copy `.env.example` to a new file named `.env`:
        ```bash
        cp .env.example .env
        ```
    *   Edit the `.env` file to set your configurations:
        *   `SECRET_KEY`: A strong, unique secret key for Flask session management and security.
        *   `DATABASE_URL`: The connection string for your PostgreSQL database (e.g., `postgresql://user:password@host:port/dbname`). For local development, it defaults to a SQLite database (`dev.db`) if `DATABASE_URL` is not set.
        *   `FLASK_ENV`: Set to `development` for development mode, or `production` for production.

5.  **Initialize the database (if using Flask-Migrate and it's the first time):**
    ```bash
    # (Ensure FLASK_APP is set, typically in .flaskenv or as an environment variable)
    # export FLASK_APP=run.py (or your main app entry point)
    flask db init  # Only if migrations directory doesn't exist
    flask db migrate -m "Initial database migration."
    flask db upgrade
    ```
    If not using Flask-Migrate, you might need to create the database and tables manually using `database_schema.sql` or by running a Python script that calls `db.create_all()` from your Flask app context.

## Running the Application

*   **Development Server:**
    ```bash
    flask run
    ```
    Or, if `run.py` is configured to start the app:
    ```bash
    python run.py
    ```
    The application will typically be available at `http://127.0.0.1:5000` (or the port specified in `run.py` or by Flask's defaults). The `emmons_frontend` expects this backend to be running on port 5001 by default, so ensure consistency or update frontend configuration.

*   **Production Deployment:**
    Use a production-ready WSGI server like Gunicorn or uWSGI. Refer to Flask and WSGI server documentation for deployment best practices.

## API Endpoints

Key API endpoints are defined in the `app/routes/` directory. Refer to the code and any API documentation (e.g., `docs/api.md`) for details on available endpoints, request/response formats, and authentication requirements.

Example (conceptual):
*   `GET /api/v1/voters?campaign_id=<id>`: Fetch voters for a campaign.
*   `POST /api/v1/interactions`: Record a new interaction.

## Testing

To run tests:
```bash
python -m unittest discover tests
```
Ensure your `FLASK_ENV` is set to `testing` or that your `TestingConfig` in `app/config.py` uses a separate test database (e.g., SQLite in-memory or a dedicated PostgreSQL test database).

## Contributing

Please refer to the main repository's contributing guidelines.
Make sure to update tests and documentation for any changes.Tool output for `create_file_with_block`:
