# Cerberus Multi-App Repository

This repository hosts a suite of applications designed for campaign management, voter data analysis, and public information dissemination. The system comprises multiple frontends and backends that work in conjunction.

## System Architecture

The Cerberus system is composed of the following main components:

1.  **`cerberus_campaigns_backend`**:
    *   **Purpose**: This is the central backend for managing voter data, campaign information, interactions, and surveys.
    *   **Technology**: Python (Flask), SQLAlchemy.
    *   **Connections**:
        *   Accessed by `emmons_frontend` for campaign-specific interactions.
        *   Accessed by `cerberus_frontend` for data upload, viewing, and administrative tasks related to campaign data.

2.  **`emmons_frontend`**:
    *   **Purpose**: A Flutter-based web application representing a specific campaign frontend (e.g., for a candidate named Emmons). It allows users (e.g., volunteers, campaign staff) to interact with voter data relevant to that campaign.
    *   **Technology**: Flutter.
    *   **Connections**:
        *   Connects to `cerberus_campaigns_backend` to fetch and submit campaign-specific data. The backend URL is is configured in `lib/src/config.dart` (currently `https://campaigns-api-885603051818.us-south1.run.app/api/v1`).

3.  **`cerberus_frontend`**:
    *   **Purpose**: A Flutter-based web application with multiple roles:
        *   **Data Portal**: Provides a user interface for uploading new data (e.g., voter lists) and viewing existing data stored in the `cerberus_campaigns_backend`.
        *   **Cerberus Report Page**: A frontend for the `cerberus_report_backend`, allowing users to search and view publicly available agenda items from municipalities.
    *   **Technology**: Flutter.
    *   **Connections**:
        *   Connects to `cerberus_campaigns_backend` for data management functionalities (specific API endpoints for this connection need to be defined/verified within the frontend's data services).
        *   Connects to `cerberus_report_backend` for the "Cerberus Report" feature. The backend URL is configured in `lib/pages/report/report_page.dart` (currently `http://api.cerberus-campaigns.com`).

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

## cerberus_campaigns_backend

The Cerberus Campaigns Backend is a Python-based Flask application responsible for managing all campaign-related data. This includes voter information, campaign details, user interactions, survey responses, and user accounts. It serves as the central data store and API for various frontend applications within the Cerberus ecosystem.

**Key Features**

*   **Voter Management**: Store and retrieve detailed voter profiles.
*   **Campaign Management**: Handle data for multiple campaigns.
*   **Interaction Tracking**: Log interactions with voters (e.g., calls, visits).
*   **Survey Management**: Store and manage survey questions and responses.
*   **User Authentication**: (Planned/To be verified) Manage user accounts and access control.
*   **API Endpoints**: Provides RESTful API endpoints for data manipulation and retrieval.

**Technology Stack**

*   **Framework**: Flask
*   **Database**: PostgreSQL (intended, uses SQLite for local development by default)
*   **ORM**: SQLAlchemy
*   **Environment Management**: `python-dotenv`

## cerberus_frontend

This Flutter-based web application serves as a multi-purpose frontend within the Cerberus ecosystem. It provides two main functionalities: a data portal for managing campaign information and the "Cerberus Report" page for accessing public municipal agenda data.

**Key Features**

1.  **Data Portal**:
    *   **Purpose**: Allows authorized users to upload, view, and manage data stored in the `cerberus_campaigns_backend`. This includes voter lists, campaign details, and potentially other administrative functions.
    *   **Connection**: Interacts with API endpoints provided by the `cerberus_campaigns_backend`.
2.  **Cerberus Report Page**:
    *   **Purpose**: Provides a user interface for searching, filtering, and viewing publicly available agenda items scraped from various municipalities. It also allows users to subscribe to email notifications for new agenda items matching their filter criteria.
    *   **Connection**: Interacts with the `cerberus_report_backend`.

**Technology Stack**

*   **Framework**: Flutter
*   **State Management**: (Verify specific state management solution used, e.g., Provider, Riverpod, BLoC - `go_router` is used for navigation)
*   **HTTP Client**: `http` package
*   **Routing**: `go_router`

## cerberus_report_backend

This directory contains the Python backend application for Cerberus, including the API, scraper, and notification sender.

## emmons_frontend

This Flutter-based web application serves as the dedicated frontend for the "Emmons for Office" campaign (or a similarly named campaign). It is designed to allow campaign staff, volunteers, and potentially the candidate to interact with voter data, record engagement activities, and manage campaign-specific information.

**Purpose**

The primary goal of this application is to provide a user-friendly interface for campaign operations, connecting directly to the `cerberus_campaigns_backend` to fetch and update data relevant to this specific campaign.

**Key Features (Conceptual / To Be Implemented)**

*   **Voter Lookup**: Search and view profiles of voters assigned to the campaign.
*   **Interaction Logging**: Record details of voter interactions (e.g., calls, canvassing visits, event attendance).
*   **Survey Data Entry**: Input responses to campaign surveys.
*   **Dashboard**: Display key campaign metrics and progress.
*   **User Roles**: (If applicable) Different views or permissions for various user types (e.g., volunteer, field organizer).

**Technology Stack**

*   **Framework**: Flutter
*   **State Management**: Riverpod (`flutter_riverpod`)
*   **HTTP Client**: `http` package
*   **Routing**: `go_router`
*   **Styling**: `google_fonts`