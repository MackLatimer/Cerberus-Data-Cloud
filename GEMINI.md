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

*   `.dockerignore`: Docker ignore file.
*   `cloudbuild.yaml`: Configuration for Google Cloud Build.
*   `.pytest_cache/`: Directory for pytest cache.
*   `.vscode/`: VS Code configuration files.
*   `cerberus_campaigns_backend/`: Contains the Flask backend for campaign and voter data.
*   `cerberus_frontend/`: Contains the Flutter frontend for the data portal and Cerberus Report page.
*   `cerberus_report_backend/`: Contains the Flask backend for scraping and serving public agenda data.
*   `emmons_frontend/`: Contains the Flutter frontend for a specific campaign.

## Getting Started

Each application directory (`cerberus_campaigns_backend`, `cerberus_frontend`, `cerberus_report_backend`, `emmons_frontend`) contains its own `README.md` file with specific setup instructions, dependencies, and usage guidelines. Please refer to those for details on how to run each component.

## Logic and Flow

### `cerberus_campaigns_backend`

*   **Framework:** Flask
*   **Database:** SQLAlchemy with PostgreSQL
*   **Core Models:**
    *   `Voter`: Represents a voter with personal information, contact details, and engagement data.
    *   `Campaign`: Represents a political campaign.
    *   `User`: Represents a user of the system (e.g., campaign staff).
    *   `Interaction`: Tracks interactions with voters (e.g., calls, website signups).
    *   `Donation`: Handles donations, integrating with Stripe for payment processing.
    *   `Survey`, `SurveyQuestion`, `SurveyResponse`: A system for creating and recording surveys.
*   **API Endpoints:**
    *   `/api/v1/voters`: CRUD operations for voters, including a CSV upload feature.
    *   `/api/v1/signups`: A public endpoint for new voter signups (e.g., from a campaign website).
    *   `/api/v1/donate`: Handles the creation of Stripe payment intents and webhook for payment confirmation.
*   **Authentication:** User authentication is handled via JWT.

### `emmons_frontend`

*   **Framework:** Flutter
*   **State Management:** `flutter_riverpod`
*   **Routing:** `go_router`
*   **Key Dependencies:**
    *   `http`: For making API calls to the backend.
    *   `flutter_stripe`: For handling Stripe payments on the frontend.
*   **Core Functionality:**
    *   The application provides a frontend for a political campaign website.
    *   It has pages for "Home", "About", "Issues", "Endorsements", and "Donate".
    *   The "Donate" page integrates with the `cerberus_campaigns_backend` to process donations using Stripe.
    *   The `config.dart` file stores the Stripe public key and the `currentCampaignId`.
*   **Connection to Backend:** The frontend communicates with the backend via REST API calls. The base URL for the API is configured in `lib/src/config.dart`.