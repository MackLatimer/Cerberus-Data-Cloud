# Cerberus-Data-Cloud Repository Analysis

This document provides a comprehensive analysis of the Cerberus-Data-Cloud repository, covering its technology stack, architecture, file structure, data models, and authentication mechanisms.

## 1. Technology Stack

The repository contains multiple services, each with its own technology stack.

### Backend Services

**`cerberus_universal_backend`**
*   **Language**: Python 3.9
*   **Framework**: Flask
*   **WSGI Server**: Gunicorn
*   **Database**: PostgreSQL with PostGIS (via `psycopg2`, `Flask-SQLAlchemy`, `GeoAlchemy2`)
*   **Key Libraries**:
    *   `cloud-sql-python-connector`: For connecting to Google Cloud SQL.
    *   `Flask-Migrate`: For database migrations.
    *   `Flask-Bcrypt`: For password hashing.
    *   `PyJWT`: For JSON Web Tokens.
    *   `stripe`: For payment processing.
*   **Deployment**: Docker container deployed on Google Cloud Platform (GCP), managed via Cloud Build.

### Frontend Applications

**`cerberus_frontend` & `emmons_frontend`**
*   **Framework**: Flutter
*   **Language**: Dart
*   **Platform**: Web
*   **Web Server**: Nginx (serves the built Flutter web application).
*   **Key Libraries**:
    *   `go_router`: For routing.
    *   `http`: For making API requests to the backend.
    *   `flutter_stripe`: For Stripe integration.
    *   `file_picker`, `video_player`, `url_launcher`: For various UI functionalities.
*   **Deployment**: Both are built as Docker containers and deployed on GCP, managed via Cloud Build.

## 2. Architectural Overview

The project follows a **hybrid, microservices-based architecture**. The frontend and backend responsibilities are clearly separated into independent services.

*   **Main Components**:
    *   **Backend API**: The `cerberus_universal_backend` provides the primary RESTful API.
    *   **Frontend Web Apps**: Two Flutter web applications (`cerberus_frontend` and `emmons_frontend`) provide the user interfaces. `emmons_frontend` appears to be a themed or campaign-specific version of the main `cerberus_frontend`.
    *   **Database**: A central **PostgreSQL** database on **Google Cloud SQL** serves as the single source of truth, storing data for all services, including geospatial information.
*   **Infrastructure**:
    *   The entire system is designed for **Google Cloud Platform**.
    *   **Docker** is used for containerization.
    *   **Cloud Build** provides CI/CD.
    *   **Google Artifact Registry** stores the container images.
    *   **Google Secret Manager** handles secrets.

## 3. Directory & File Breakdown

*   **`cerberus_universal_backend/`**: The core backend API. Contains `app/` (models, routes), `migrations/`, `tests/`, and a `Dockerfile`.
*   **`cerberus_frontend/`**: The main Flutter web app. Contains `lib/` (Dart source code), `web/` assets, `pubspec.yaml`, and a `Dockerfile`.
*   **`emmons_frontend/`**: A second, campaign-specific Flutter web app with a structure nearly identical to `cerberus_frontend`.
*   **`cloudbuild.yaml`**: The root-level CI/CD pipeline definition for GCP.

## 4. Data Models & Schema

The database schema, defined with SQLAlchemy, is designed for a political campaign or voter relationship management (VRM) platform.

*   **Core Entities**:
    *   `Person`: A detailed model for individuals (voters, contacts) storing demographic, contact, and preference data.
    *   `Campaign`: Represents a political or issue-based campaign.
    *   `User`: An application user with credentials and a role for access control.
    *   `Donation`: A financial contribution, linked to a `Person` and a `Campaign`.
*   **Relationships**:
    *   `Person` and `Campaign` are linked through interactions and donations.
    *   `Users` (e.g., campaign staff) log interactions with `Persons`.
*   **Security**:
    *   `User` passwords are a a hashed using `bcrypt`.
    *   Sensitive PII in the `Donation` model (email, phone) is encrypted in the database using a custom `EncryptedString` type.
*   **Other Notable Models**: `Voter`, `VoterHistory`, `Interaction`, `Address`, `District`, `AuditLog`.

## 5. Authentication & Authorization

The authentication mechanism is not fully implemented or visible in the repository.

*   **Components Available**: The project includes the necessary libraries (`Flask-Bcrypt`, `PyJWT`) and a `User` model with password hashing, indicating that a local username/password system with JWTs was intended.
*   **Missing Implementation**: There is no visible code for:
    *   A login endpoint to exchange credentials for a JWT.
    *   A JWT validation mechanism (e.g., a Flask decorator) to protect the API endpoints.
*   **Conclusion**: It is unclear how authentication is handled. The API endpoints in `voters_api_bp` appear to be unprotected in the application code, which could pose a significant security risk if they are not secured by other means (e.g., an API gateway or cloud-level access control).
