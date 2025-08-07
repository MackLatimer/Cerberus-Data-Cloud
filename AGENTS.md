# Cerberus Agents

This document outlines the agents and tools within the Cerberus repository, providing guidance on how to interact with them for development, testing, and deployment tasks. This file is intended to be used by Jules to understand the project and assist with tasks.

## Getting Started with Jules

To get started with Jules, you need to:

1.  **Login**: Visit [jules.google.com](https://jules.google.com) and sign in with your Google account.
2.  **Connect to GitHub**: Grant Jules access to your repositories. You can choose to connect all or specific repositories.
3.  **Start a Task**: Select a repository and branch, then provide a clear and specific prompt describing the task you want Jules to perform. For example, "Add a test for the `Voter` model in `cerberus_campaigns_backend`."

## Codebase Agents

The Cerberus system is composed of the following main components:

### 1. `cerberus_campaigns_backend`

*   **Purpose**: This is the central backend for managing voter data, campaign information, interactions, and surveys.
*   **Technology**: Python (Flask), Google Cloud SQL (PostgreSQL).
*   **Interaction**:
    *   To run the backend, navigate to the `cerberus_campaigns_backend` directory and run `python run.py`.
    *   To run tests, navigate to the `cerberus_campaigns_backend` directory and run `pytest`.
    *   The API is documented in `cerberus_campaigns_backend/docs/api.md`.

### 2. `emmons_frontend`

*   **Purpose**: A Flutter-based web application representing a specific campaign frontend (e.g., for a candidate named Emmons). It allows users (e.g., volunteers, campaign staff) to interact with voter data relevant to that campaign.
*   **Technology**: Flutter.
*   **Interaction**:
    *   To run the frontend, navigate to the `emmons_frontend` directory and run `flutter run -d chrome`.
    *   The frontend connects to the `cerberus_campaigns_backend`. The backend URL is configured in `lib/src/config.dart`.

### 3. `cerberus_frontend`

*   **Purpose**: A Flutter-based web application with multiple roles:
    *   **Data Portal**: Provides a user interface for uploading new data (e.g., voter lists) and viewing existing data stored in the `cerberus_campaigns_backend`.
    *   **Cerberus Report Page**: A frontend for the `cerberus_report_backend`, allowing users to search and view publicly available agenda items from municipalities.
*   **Technology**: Flutter.
*   **Interaction**:
    *   To run the frontend, navigate to the `cerberus_frontend` directory and run `flutter run -d chrome`.
    *   The frontend connects to both the `cerberus_campaigns_backend` and the `cerberus_report_backend`. The backend URLs are configured in `lib/api_config.dart` and `lib/pages/report/report_page.dart`.

### 4. `cerberus_report_backend`

*   **Purpose**: This backend scrapes, stores, and provides an API for public municipal agenda items. It also handles user subscriptions for notifications about new agenda items.
*   **Technology**: Python (Flask), Google Cloud SQL (PostgreSQL).
*   **Interaction**:
    *   To run the backend, navigate to the `cerberus_report_backend` directory and run `python api.py`.
    *   To run the scraper, navigate to the `cerberus_report_backend` directory and run `python scraper.py`.
    *   To run tests, navigate to the `cerberus_report_backend` directory and run `pytest`.

## Tools

### `get_timestamp.py`

*   **Purpose**: A simple Python script that prints the current timestamp.
*   **Interaction**: Run `python get_timestamp.py` to get the current timestamp.

### `new_schema.sql` and `new_schema_fixed.sql`

*   **Purpose**: These files contain SQL schemas for the `cerberus_campaigns_backend` database.
*   **Interaction**: These files can be used to set up the database schema.

### `cloudbuild.yaml`

*   **Purpose**: This file contains the configuration for Google Cloud Build.
*   **Interaction**: This file is used by Google Cloud Build to build and deploy the applications.
