# AGENTS.md: AI Agent Onboarding

This document provides a comprehensive guide for AI agents to understand, set up, and contribute to the Cerberus Data Cloud project.

## 1. Project Overview

Cerberus Data Cloud is a suite of applications for campaign management, voter data analysis, and public information dissemination. The project consists of three main components:

*   **`cerberus_universal_backend`**: A Python (Flask) backend that serves as the central API for managing campaign and voter data.
*   **`cerberus_frontend`**: A Flutter web application that provides a data portal for managing data in the backend and a "Cerberus Report" page for viewing public municipal agenda items.
*   **`universal_campaign_frontend`**: A Flutter web application that serves as a template for creating campaign-specific public-facing websites.

## 2. Technologies

The project utilizes the following technologies:

*   **Backend**: Python, Flask, SQLAlchemy, PostgreSQL (with PostGIS), Gunicorn, Docker
*   **Frontend**: Flutter, Dart, Nginx, Docker
*   **DevOps**: Google Cloud Platform (GCP), Cloud Build, Docker Compose

## 3. Getting Started

To set up the development environment, you will need to have the following installed:

*   Python 3.9 or later
*   Flutter SDK 3.22.2 or later
*   Docker and Docker Compose

Each application component has its own setup and run instructions. Please refer to the specific sections below for details.

## 4. Backend (`cerberus_universal_backend`)

The backend is a Flask application that provides a RESTful API for managing campaign and voter data.

### 4.1. Dependencies

The Python dependencies are listed in `cerberus_universal_backend/requirements.txt`. Key dependencies include:

*   Flask
*   SQLAlchemy
*   Flask-Migrate
*   Flask-Bcrypt
*   gunicorn
*   google-cloud-secret-manager

### 4.2. Running the Application

#### Local Development (without Docker)

1.  Create a Python virtual environment.
2.  Install the dependencies: `pip install -r requirements.txt`
3.  Create a `.env` file in the `cerberus_universal_backend` directory with the required environment variables (see `docker-compose.yml` for a list of variables).
4.  Run the database migrations: `flask db upgrade`
5.  Start the application: `python run.py`

#### Docker

The recommended way to run the backend for development is using Docker Compose.

1.  Navigate to the `cerberus_universal_backend` directory.
2.  Run `docker-compose up`.

This will start the Flask application and a PostgreSQL database in separate containers. The application will be accessible at `http://localhost:8080`.

### 4.3. Testing

The tests are located in the `cerberus_universal_backend/tests` directory. To run the tests, use `pytest`.

```bash
pytest
```

### 4.4. Database

The application uses a PostgreSQL database with the PostGIS extension for geospatial data. The database schema is managed using Flask-Migrate. The migration scripts are located in `cerberus_universal_backend/migrations`.

## 5. Frontend (`cerberus_frontend`)

The main frontend is a Flutter web application that provides a data portal and a report page.

### 5.1. Dependencies

The Flutter dependencies are listed in `cerberus_frontend/pubspec.yaml`. Key dependencies include:

*   go_router
*   http
*   file_picker
*   flutter_stripe

### 5.2. Running the Application

1.  Navigate to the `cerberus_frontend` directory.
2.  Get the dependencies: `flutter pub get`
3.  Run the application: `flutter run -d chrome`

The application will be accessible at `http://localhost:<port>`.

### 5.3. Building for Production

To build the application for production, run the following command:

```bash
flutter build web --release
```

This will create a `build/web` directory with the compiled application. The `Dockerfile` in the `cerberus_frontend` directory shows how to serve this application with Nginx.

## 6. Campaign Frontend (`universal_campaign_frontend`)

The campaign frontend is a Flutter web application that can be configured for different campaigns.

### 6.1. Dependencies

The Flutter dependencies are listed in `universal_campaign_frontend/pubspec.yaml`.

### 6.2. Running the Application

1.  Navigate to the `universal_campaign_frontend` directory.
2.  Get the dependencies: `flutter pub get`
3.  Run the application with a specific campaign: `flutter run -d chrome --dart-define=CAMPAIGN_ID=<campaign_id>`

The application will load the configuration for the specified campaign.

### 6.3. Configuration

The application's configuration is loaded dynamically based on a `campaign` query parameter in the URL. The `ConfigService.loadCampaignConfig` method is responsible for loading the campaign-specific configuration. The configuration files are located in `universal_campaign_frontend/assets`.
