# Cerberus Campaigns Backend

## Overview

The Cerberus Campaigns Backend is a Python-based Flask application responsible for managing all campaign-related data. This includes voter information, campaign details, user interactions, survey responses, and user accounts. It serves as the central data store and API for various frontend applications within the Cerberus ecosystem.

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
*   **Database**: PostgreSQL (intended, uses SQLite for local development by default)
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