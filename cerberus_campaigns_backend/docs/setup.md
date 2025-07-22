# Cerberus Backend Local Setup and Running

This guide provides instructions for setting up and running the Cerberus backend application locally for development and testing.

## Prerequisites

-   Python 3.10+
-   `pip` (Python package installer)
-   `git` (for cloning the repository)
-   Access to a PostgreSQL database instance (either local or cloud-based like Google Cloud SQL).
    -   The application is configured to connect to PostgreSQL. For testing, it can fall back to SQLite, but some features (like JSONB operations) are best tested against PostgreSQL.

## 1. Clone the Repository

```bash
git clone <repository_url>
cd <repository_name>/cerberus_backend
```

## 2. Create and Activate Virtual Environment

It's highly recommended to use a virtual environment to manage project dependencies.

```bash
# From the cerberus_backend directory
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

## 3. Install Dependencies

Install all required Python packages:

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

## 4. Configure Environment Variables

The application uses a `.env` file to manage environment-specific configurations, especially database connection details and secret keys.

1.  **Copy the example file:**
    ```bash
    cp .env.example .env
    ```

2.  **Edit `.env` file:**
    Open the newly created `.env` file and update the following variables:

    -   `FLASK_APP`: Should be `run.py` (usually pre-filled).
    -   `FLASK_ENV`: Set to `development` for local development.
    -   `SECRET_KEY`: **Important!** Change this to a long, random, and secret string. This key is used for session management and security. You can generate one using `python -c 'import secrets; print(secrets.token_hex(24))'`.
    -   `DATABASE_URL`: This is the most critical part for database connection.
        -   **For Google Cloud SQL (PostgreSQL) via Cloud SQL Proxy:**
            -   Ensure the Cloud SQL Proxy is running and configured for your instance.
            -   The format is typically:
                `DATABASE_URL="postgresql://<DB_USER>:<DB_PASSWORD>@/<DB_NAME>?host=/cloudsql/<PROJECT_ID>:<REGION>:<INSTANCE_NAME>"`
                *Example:* `DATABASE_URL="postgresql://campaign_user:mysecretpassword@/campaign_data?host=/cloudsql/myproject:us-central1:cerberus-data-cloud"`
        -   **For a local PostgreSQL instance:**
            `DATABASE_URL="postgresql://<DB_USER>:<DB_PASSWORD>@localhost:5432/<DB_NAME>"`
            *Example:* `DATABASE_URL="postgresql://campaign_user:localpass@localhost:5432/campaign_data_dev"`
        -   **For local development with SQLite (fallback, not recommended for full feature testing):**
            If you don't set `DATABASE_URL`, the `DevelopmentConfig` in `app/config.py` defaults to a local SQLite file (`dev.db`). This is useful for quick starts but won't test PostgreSQL-specific features.

    -   `TEST_DATABASE_URL` (Optional, for running tests):
        -   If you want tests to run against a separate PostgreSQL test database, set this variable in your environment or `.env` file.
        -   If not set, tests will default to an in-memory SQLite database (`sqlite:///:memory:`), as configured in `app/config.py` (`TestingConfig`). Note that PostgreSQL-specific JSONB types may not be fully compatible with SQLite.

## 5. Database Setup and Migrations

Once your `DATABASE_URL` is configured to point to your PostgreSQL database:

1.  **Ensure the database exists:** The database specified in `DATABASE_URL` (e.g., `campaign_data`) must be created in your PostgreSQL instance. The application/migrations will not create the database itself, only the schema within it.

2.  **Initialize Flask-Migrate (if first time and `migrations` folder doesn't exist):**
    ```bash
    # Ensure FLASK_APP and FLASK_ENV are effectively set (e.g., from .env or exported)
    # export FLASK_APP=run.py
    # export FLASK_ENV=development
    flask db init
    ```
    *This creates the `migrations` directory. This step is usually only needed once per project.*

3.  **Create an initial migration (if models exist but no migrations yet):**
    If you have models defined and this is the first migration:
    ```bash
    flask db migrate -m "Initial database schema."
    ```

4.  **Apply migrations to create tables:**
    This command applies all pending migrations to set up or update your database schema according to the models.
    ```bash
    flask db upgrade
    ```
    *Run `flask db migrate` and `flask db upgrade` whenever you make changes to your SQLAlchemy models.*

## 6. Running the Development Server

To run the Flask development server:

```bash
python run.py
```

By default, this will start the server on `http://127.0.0.1:5001` (or the port specified in `run.py` / `PORT` env var).
The `FLASK_ENV=development` setting ensures debug mode is active, providing helpful error messages and auto-reloading on code changes.

## 7. Running Tests

To run the automated tests:

1.  Ensure your virtual environment is active and dependencies (including `pytest`, `pytest-flask`) are installed.
2.  If you want to test against a specific PostgreSQL test database, make sure `TEST_DATABASE_URL` is set in your environment or `.env` file. Otherwise, tests will use in-memory SQLite.
3.  From the `cerberus_backend` directory:
    ```bash
    pytest
    ```
    Or, for more verbose output:
    ```bash
    pytest -v -s tests
    ```

You should now have the backend application running locally!
