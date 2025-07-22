# Cerberus Frontend

This Flutter-based web application serves as a multi-purpose frontend within the Cerberus ecosystem. It provides two main functionalities: a data portal for managing campaign information and the "Cerberus Report" page for accessing public municipal agenda data.

## Key Features

1.  **Data Portal**:
    *   **Purpose**: Allows authorized users to upload, view, and manage data stored in the `cerberus_campaigns_backend`. This includes voter lists, campaign details, and potentially other administrative functions.
    *   **Connection**: Interacts with API endpoints provided by the `cerberus_campaigns_backend`. (Specific API endpoints and data services for this connection need to be implemented/verified within the `lib` directory, possibly under a `services` or `providers` folder).

2.  **Cerberus Report Page**:
    *   **Purpose**: Provides a user interface for searching, filtering, and viewing publicly available agenda items scraped from various municipalities. It also allows users to subscribe to email notifications for new agenda items matching their filter criteria.
    *   **Connection**: Interacts with the `cerberus_report_backend`. The backend API URL is configured in `lib/pages/report/report_page.dart` (currently `https://agenda-api-service-885603051818.us-south1.run.app`).

## Technology Stack

*   **Framework**: Flutter
*   **State Management**: (Verify specific state management solution used, e.g., Provider, Riverpod, BLoC - `go_router` is used for navigation)
*   **HTTP Client**: `http` package
*   **Routing**: `go_router`

## Project Structure

*   `lib/`: Main application Dart code.
    *   `main.dart`: Entry point of the application, sets up routing and initial theme.
    *   `models/`: Data models (e.g., `agenda_item.dart`).
    *   `pages/`: UI for different pages/screens of the application.
        *   `home/`: Home page.
        *   `about/`: About page.
        *   `contact/`: Contact page.
        *   `report/`: Cerberus Report page, including logic for fetching and displaying agenda items.
        *   (Potentially other pages for data portal functionality, e.g., `data_upload_page.dart`, `voter_view_page.dart`).
    *   `widgets/`: Reusable UI components.
    *   (Potentially `services/` or `providers/` for business logic and API interactions).
*   `web/`: Web-specific files, including `index.html`.
*   `assets/`: Static assets like images and fonts.
*   `pubspec.yaml`: Flutter project configuration, including dependencies.
*   `README.md`: This file.

## Setup and Installation

1.  **Install Flutter:**
    Ensure you have Flutter installed on your system. Follow the official Flutter installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

2.  **Clone the repository (if you haven't already):**
    ```bash
    git clone <repository_url>
    cd <repository_directory>/cerberus_frontend
    ```

3.  **Get dependencies:**
    ```bash
    flutter pub get
    ```

## Running the Application

1.  **Ensure Backends are Running:**
    *   For the **Cerberus Report Page** to function, the `cerberus_report_backend` must be running and accessible at the URL configured in `lib/pages/report/report_page.dart`.
    *   For the **Data Portal** functionality, the `cerberus_campaigns_backend` must be running and its API endpoints correctly integrated into the frontend.

2.  **Run the application (web):**
    ```bash
    flutter run -d chrome
    ```
    This will launch the application in a Chrome browser. You can replace `chrome` with other supported browsers like `edge`.

    The application will typically be available at `http://localhost:<port_number>`.

## Building for Deployment (Web)

To create a release build for the web:
```bash
flutter build web
```
The output will be placed in the `build/web` directory. These files can then be deployed to any static web hosting service.

## Key Configuration Points

*   **`cerberus_report_backend` URL**: Located in `lib/pages/report/report_page.dart`, variable `_apiBaseUrl`.
    ```dart
    final String _apiBaseUrl = 'https://agenda-api-service-885603051818.us-south1.run.app';
    ```
*   **`cerberus_campaigns_backend` URL**: The connection to this backend for data portal features needs to be implemented. This would likely involve defining a base URL in a configuration file (e.g., `lib/config.dart` or similar) and using it in services that make API calls.

## Development Notes

*   **CORS**: When developing locally, if the frontend (`flutter run`) and a backend (e.g., a locally running Flask server) are on different ports (e.g., Flutter on `localhost:12345`, Flask on `localhost:5000`), you might encounter CORS (Cross-Origin Resource Sharing) issues. Ensure the backend is configured to allow requests from the Flutter development server's origin.
    *   For Flask backends, this typically involves configuring the `Flask-CORS` extension.

## Contributing

Please refer to the main repository's contributing guidelines.
When adding new features or pages:
*   Update routes in `lib/main.dart` if necessary.
*   Ensure new UI components are responsive and follow the application's design language.
*   Add any new models to the `lib/models/` directory.
*   For features interacting with backends, encapsulate API calls in service classes.Tool output for `overwrite_file_with_block`:
