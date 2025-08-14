# Cerberus Universal Backend

## Overview

The Cerberus Universal Backend is a Python-based Flask application responsible for managing all campaign-related data. This includes voter information, campaign details, user interactions, survey responses, and user accounts. It serves as the central data store and API for various frontend applications within the Cerberus ecosystem.

## Key Features

*   **Voter Management**: Store and retrieve detailed voter profiles. Includes functionality for CSV upload of voter lists.
*   **Campaign Management**: Handle data for multiple campaigns.
*   **Interaction Tracking**: Log interactions with voters (e.g., calls, visits, website signups).
*   **Survey Management**: Store and manage survey questions and responses.
*   **Donations**: Process donations through Stripe, including a webhook for payment status updates.
*   **Public Signup Endpoint**: A dedicated endpoint for public-facing websites to submit new signups.
*   **User Authentication**: (Planned/To be verified) Manage user accounts and access control.
*   **API Endpoints**: Provides RESTful API endpoints for data manipulation and retrieval.

## Technology Stack

*   **Framework**: Flask
*   **Database**: PostgreSQL
*   **ORM**: SQLAlchemy
*   **Environment Management**: `python-dotenv`
*   **Migrations**: Flask-Migrate
*   **Testing**: Pytest

## Project Structure

*   `app/`: Main application directory.
    *   `models/`: SQLAlchemy database models (e.g., `voter.py`, `campaign.py`).
    *   `routes/`: Flask blueprints defining API endpoints (e.g., `voters.py`, `donate.py`).
    *   `__init__.py`: Application factory.
    *   `config.py`: Configuration classes (Development, Testing, Production).
    *   `extensions.py`: Flask extension initializations (e.g., SQLAlchemy, Migrate).
*   `migrations/`: Database migration scripts.
*   `tests/`: Unit and integration tests.
*   `.env.example`: Example environment variable file.
*   `requirements.txt`: Python package dependencies.
*   `run.py`: Script to run the Flask development server.
*   `database_schema.sql`: SQL schema definition.

## Models

*   **Campaign**: Represents a political campaign.
*   **Voter**: Represents a voter.
*   **CampaignVoter**: A many-to-many relationship between campaigns and voters.
*   **Interaction**: Represents an interaction with a voter.
*   **SurveyQuestion**: Represents a question in a survey.
*   **SurveyResponse**: Represents a voter's response to a survey question.
*   **Donation**: Represents a donation made to a campaign.
*   **User**: Represents a user of the system.

## API Endpoints

### Public API (`/api/v1`)

*   **POST /signups**: Creates a new voter and interaction from a public signup form.

### Voters API (`/api/v1/voters`)

*   **POST /**: Creates a new voter.
*   **GET /**: Lists all voters with pagination.
*   **GET /<voter_id>**: Retrieves a single voter by ID.
*   **PUT /<voter_id>**: Updates a voter's information.
*   **DELETE /<voter_id>**: Deletes a voter.
*   **POST /upload**: Uploads a CSV file of voters.

### Donate API (`/api/v1/donate`)

*   **POST /create-payment-intent**: Creates a Stripe Payment Intent for a donation.
*   **POST /update-donation-details**: Updates a donation with additional details after payment.
*   **POST /webhook**: Handles Stripe webhooks for payment status updates.

## Configuration Details

The application's configuration is managed through environment variables and the `app/config.py` file. It supports different configurations for development, testing, and production environments, determined by the `FLASK_ENV` environment variable.

### Environment Variables

The application uses a `.env` file to load environment variables. The file is expected to be in the root of the `cerberus_universal_backend` directory.

*   `SECRET_KEY`: A strong, unique secret key for Flask session management and security.
*   `DATABASE_URL`: The connection string for your PostgreSQL database. This is required for the application to run. For connecting to a local PostgreSQL instance, you can use a URL like `postgresql+psycopg://campaign_user:local_password@localhost:5432/campaign_data`. If you are using a Cloud SQL instance, ensure the Cloud SQL proxy is running.
*   `TEST_DATABASE_URL`: A separate database URL for running tests. It is highly recommended to use a separate database for testing to avoid data conflicts.
*   `FLASK_ENV`: Set to `development`, `testing`, or `production`.
*   `STRIPE_SECRET_KEY`: Your Stripe secret key.
*   `STRIPE_WEBHOOK_SECRET`: Your Stripe webhook secret.

### Production Configuration Notes

For production deployments, it is recommended to:
*   Use a production-ready WSGI server like Gunicorn.
*   Enable security enhancements in the configuration, such as `SESSION_COOKIE_SECURE` and `SESSION_COOKIE_HTTPONLY`.

## Setup and Installation

1.  **Clone the repository (if you haven't already):**
    ```bash
    git clone <repository_url>
    cd <repository_directory>/cerberus_universal_backend
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
    For development, also install the development dependencies:
    ```bash
    pip install -r requirements-dev.txt
    ```

4.  **Configure environment variables:**
    *   Copy `.env.example` to a new file named `.env`:
        ```bash
        cp .env.example .env
        ```
    *   Edit the `.env` file to set your configurations:
        *   `FLASK_SECRET_KEY`: A strong, unique secret key for Flask session management and security.
        *   `DATABASE_URL`: The connection string for your PostgreSQL database (e.g., `postgresql://user:password@host:port/dbname`).
        *   `FLASK_ENV`: Set to `development` for development mode, or `production` for production.
        *   `STRIPE_SECRET_KEY`: Your Stripe secret key.
        *   `STRIPE_WEBHOOK_SECRET`: Your Stripe webhook secret.

5.  **Initialize the database:**
    ```bash
    flask db upgrade
    ```

## Running the Application

*   **Development Server:**
    ```bash
    flask run
    ```
    The application will be available at `http://127.0.0.1:5000`.

*   **Production Deployment:**
    Use a production-ready WSGI server like Gunicorn.

## Testing

To run tests:
```bash
pytest
```