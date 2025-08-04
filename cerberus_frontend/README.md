# Cerberus Frontend

This Flutter-based web application serves as a multi-purpose frontend within the Cerberus ecosystem. It provides two main functionalities: a data portal for managing campaign information and the "Cerberus Report" page for accessing public municipal agenda data.

## Key Features

1.  **Data Portal**:
    *   **Purpose**: Allows authorized users to upload, view, and manage data stored in the `cerberus_campaigns_backend`. This includes voter lists, campaign details, and potentially other administrative functions.
    *   **Connection**: Interacts with API endpoints provided by the `cerberus_campaigns_backend`.

2.  **Cerberus Report Page**:
    *   **Purpose**: Provides a user interface for searching, filtering, and viewing publicly available agenda items scraped from various municipalities. It also allows users to subscribe to email notifications for new agenda items matching their filter criteria.
    *   **Connection**: Interacts with the `cerberus_report_backend`.

## Technology Stack

*   **Framework**: Flutter
*   **HTTP Client**: `http` package
*   **Routing**: `go_router`
*   **File Picking**: `file_picker`
*   **Video Player**: `video_player`
*   **Stripe**: `flutter_stripe`

## Project Structure

*   `lib/`: Main application Dart code.
    *   `main.dart`: Entry point of the application, sets up routing and initial theme.
    *   `models/`: Data models (e.g., `agenda_item.dart`).
    *   `pages/`: UI for different pages/screens of the application.
        *   `home/`: Home page.
        *   `about/`: About page.
        *   `contact/`: Contact page.
        *   `report/`: Cerberus Report page, including logic for fetching and displaying agenda items.
        *   `upload/`: Page for uploading voter data.
    *   `widgets/`: Reusable UI components.
*   `web/`: Web-specific files, including `index.html`.
*   `assets/`: Static assets like images and fonts.
*   `pubspec.yaml`: Flutter project configuration, including dependencies.
*   `README.md`: This file.

## Pages

*   **Home Page**: The landing page of the application. It provides a brief overview of what Cerberus Campaigns does and includes a call to action to join their email and text list.
*   **About Page**: Provides more information about Cerberus Campaigns.
*   **Contact Page**: A page with contact information.
*   **Report Page**: The "Cerberus Report" feature. It allows users to search and filter public municipal agenda items. It also includes a feature to subscribe to email notifications for new agenda items that match the user's filter criteria. This page interacts with the `cerberus_report_backend`.
*   **Upload Page**: Provides a user interface for uploading CSV files of voter data. This page interacts with the `cerberus_campaigns_backend`.

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

## Building for Deployment (Web)

To create a release build for the web:
```bash
flutter build web
```
The output will be placed in the `build/web` directory. These files can then be deployed to any static web hosting service.

## Key Configuration Points

*   **`cerberus_report_backend` URL**: Located in `lib/pages/report/report_page.dart`, variable `_apiBaseUrl`.
    ```dart
    final String _apiBaseUrl = 'http://api.cerberus-campaigns.com';
    ```
*   **`cerberus_campaigns_backend` URL**: Located in `lib/pages/upload/upload_page.dart`.
    ```dart
    var uri = Uri.parse('http://127.0.0.1:5001/api/v1/voters/upload');
    ```

## Development Notes

*   **CORS**: When developing locally, if the frontend (`flutter run`) and a backend (e.g., a locally running Flask server) are on different ports (e.g., Flutter on `localhost:12345`, Flask on `localhost:5000`), you might encounter CORS (Cross-Origin Resource Sharing) issues. Ensure the backend is configured to allow requests from the Flutter development server's origin.
    *   For Flask backends, this typically involves configuring the `Flask-CORS` extension.