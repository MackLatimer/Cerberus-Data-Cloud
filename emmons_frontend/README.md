# Emmons Campaign Frontend

This Flutter-based web application serves as the dedicated frontend for the "Emmons for Office" campaign (or a similarly named campaign). It is designed to allow campaign staff, volunteers, and potentially the candidate to interact with voter data, record engagement activities, and manage campaign-specific information.

## Purpose

The primary goal of this application is to provide a user-friendly interface for campaign operations, connecting directly to the `cerberus_campaigns_backend` to fetch and update data relevant to this specific campaign.

## Key Features (Conceptual / To Be Implemented)

*   **Voter Lookup**: Search and view profiles of voters assigned to the campaign.
*   **Interaction Logging**: Record details of voter interactions (e.g., calls, canvassing visits, event attendance).
*   **Survey Data Entry**: Input responses to campaign surveys.
*   **Dashboard**: Display key campaign metrics and progress.
*   **User Roles**: (If applicable) Different views or permissions for various user types (e.g., volunteer, field organizer).

## Technology Stack

*   **Framework**: Flutter
*   **State Management**: Riverpod (`flutter_riverpod`)
*   **HTTP Client**: `http` package
*   **Routing**: `go_router`
*   **Styling**: `google_fonts`

## Connection to Backend

*   This frontend connects to the `cerberus_campaigns_backend`.
*   The base URL for the backend API is configured in `lib/src/config.dart`:
    ```dart
    // For local development with Flask backend running on port 5001:
    const String apiBaseUrl = 'http://127.0.0.1:5001/api/v1';
    // Example for a deployed backend:
    // const String apiBaseUrl = 'https://your-backend-service-url.com/api/v1';
    ```
*   The `currentCampaignId` is also set in this file, which is likely used to scope API requests to this specific campaign:
    ```dart
    const int currentCampaignId = 1; // TODO: Ensure this ID matches the campaign in the backend
    ```

## Project Structure

*   `lib/`: Main application Dart code.
    *   `main.dart`: Entry point of the application, sets up Riverpod providers and GoRouter.
    *   `src/`: Core application logic and UI.
        *   `config.dart`: Application configuration, including API base URL and campaign ID.
        *   `pages/`: UI for different pages/screens (e.g., `HomePage`, `VoterDetailsPage`, `LogInteractionPage`).
        *   `widgets/`: Reusable UI components.
        *   `models/`: (Likely location for data models, though not explicitly shown in current file list).
        *   `providers/` or `services/`: (Likely location for Riverpod providers and API service classes).
*   `web/`: Web-specific files, including `index.html`.
*   `assets/`: Static assets like images (e.g., `CurtisEmmonsRepublicanPrimarySquare.png`) and fonts.
*   `pubspec.yaml`: Flutter project configuration, including dependencies.
*   `README.md`: This file.

## Setup and Installation

1.  **Install Flutter:**
    Ensure you have Flutter installed on your system. Follow the official Flutter installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

2.  **Clone the repository (if you haven't already):**
    ```bash
    git clone <repository_url>
    cd <repository_directory>/emmons_frontend
    ```

3.  **Get dependencies:**
    ```bash
    flutter pub get
    ```

## Running the Application

1.  **Ensure Backend is Running:**
    The `cerberus_campaigns_backend` must be running and accessible at the URL configured in `lib/src/config.dart` (e.g., `http://127.0.0.1:5001`).

2.  **Run the application (web):**
    ```bash
    flutter run -d chrome
    ```
    This will launch the application in a Chrome browser. You can replace `chrome` with other supported browsers.

    The application will typically be available at `http://localhost:<port_number>`.

## Building for Deployment (Web)

To create a release build for the web:
```bash
flutter build web
```
The output will be placed in the `build/web` directory. These files can then be deployed to any static web hosting service.

## Key Configuration Points

*   **API Base URL**: `lib/src/config.dart` -> `apiBaseUrl`
    *   For local development, this is set to `http://127.0.0.1:5001/api/v1`.
    *   **For GCP Deployment**: Before building the frontend for deployment (e.g., via Cloud Build), you **MUST** update this `apiBaseUrl` to the URL of your deployed `campaigns-api` Cloud Run service. For example:
        ```dart
        // const String apiBaseUrl = 'http://127.0.0.1:5001/api/v1'; // Local
        const String apiBaseUrl = 'https://campaigns-api-YOUR_SERVICE_HASH-REGION.a.run.app/api/v1'; // Deployed
        ```
        Replace `https://campaigns-api-YOUR_SERVICE_HASH-REGION.a.run.app` with the actual URL provided by Cloud Run for your `campaigns-api` service.
        Future improvements might involve a runtime configuration mechanism (e.g., loading a `config.json`) to avoid manual changes before each build for different environments.
*   **Campaign ID**: `lib/src/config.dart` -> `currentCampaignId`
    *   Ensure this ID matches an existing campaign in the `cerberus_campaigns_backend` database.

Ensure these are correctly set for your development or production environment.

## Development Notes

*   **CORS**: If developing locally and the `cerberus_campaigns_backend` is running on a different port, ensure the backend's CORS policy allows requests from the Flutter development server's origin (e.g., `http://localhost:port_flutter_is_using`).
*   **Riverpod Providers**: State and services are managed using Riverpod. Familiarize yourself with Riverpod patterns for fetching data, managing state, and interacting with services.
*   **GoRouter**: Navigation is handled by `go_router`. Define new routes and path parameters as needed.

## Contributing

Please refer to the main repository's contributing guidelines.
When adding new features:
*   Create new pages under `lib/src/pages/`.
*   Develop reusable widgets under `lib/src/widgets/`.
*   Define necessary Riverpod providers for state management and service access.
*   Ensure API interactions are clearly defined, possibly in dedicated service classes.
*   Update routes in your GoRouter configuration.
*   Add appropriate tests.
