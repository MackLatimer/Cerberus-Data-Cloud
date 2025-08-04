# Cerberus Multi-App Repository

This repository hosts a suite of applications designed for campaign management, voter data analysis, and public information dissemination. The system comprises multiple frontends and backends that work in conjunction.

## System Architecture

The Cerberus system is composed of the following main components:

1.  **`cerberus_campaigns_backend`**:
    *   **Purpose**: This is the central backend for managing voter data, campaign information, interactions, and surveys. It also handles donations via Stripe.
    *   **Technology**: Python (Flask), SQLAlchemy.
    *   **Connections**:
        *   Accessed by `emmons_frontend` for campaign-specific interactions.
        *   Accessed by `cerberus_frontend` for data upload, viewing, and administrative tasks related to campaign data.

2.  **`emmons_frontend`**:
    *   **Purpose**: A Flutter-based web application representing a specific campaign frontend (e.g., for a candidate named Emmons). It serves as the public-facing website for the campaign.
    *   **Technology**: Flutter.
    *   **Connections**:
        *   Connects to `cerberus_campaigns_backend` to handle signups and donations.

3.  **`cerberus_frontend`**:
    *   **Purpose**: A Flutter-based web application with multiple roles:
        *   **Data Portal**: Provides a user interface for uploading new data (e.g., voter lists) and viewing existing data stored in the `cerberus_campaigns_backend`.
        *   **Cerberus Report Page**: A frontend for the `cerberus_report_backend`, allowing users to search and view publicly available agenda items from municipalities.
    *   **Technology**: Flutter.
    *   **Connections**:
        *   Connects to `cerberus_campaigns_backend` for data management functionalities.
        *   Connects to `cerberus_report_backend` for the "Cerberus Report" feature.

4.  **`cerberus_report_backend`**:
    *   **Purpose**: This backend scrapes, stores, and provides an API for public municipal agenda items. It also handles user subscriptions for notifications about new agenda items.
    *   **Technology**: Python (Flask), Google Cloud SQL (PostgreSQL).
    *   **Connections**:
        *   Accessed by `cerberus_frontend` (Report Page) to display agenda data and manage subscriptions.

## Directory Structure

*   `cerberus_campaigns_backend/`: Contains the Flask backend for campaign and voter data.
*   `cerberus_frontend/`: Contains the Flutter frontend for the data portal and Cerberus Report page.
*   `cerberus_report_backend/`: Contains the Flask backend for scraping and serving public agenda data.
*   `emmons_frontend/`: Contains the Flutter frontend for a specific campaign.
*   `cloudbuild.yaml`: Configuration for Google Cloud Build.

## Getting Started

Each application directory (`cerberus_campaigns_backend`, `cerberus_frontend`, `cerberus_report_backend`, `emmons_frontend`) contains its own `README.md` file with specific setup instructions, dependencies, and usage guidelines. Please refer to those for details on how to run each component.