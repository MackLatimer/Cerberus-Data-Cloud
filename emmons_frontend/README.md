# Emmons Campaign Frontend

This Flutter-based web application serves as the dedicated public-facing website for the "Emmons for Office" campaign.

## Purpose

The primary goal of this application is to provide a professional and informative online presence for the campaign, allowing visitors to learn about the candidate, the issues, and how to get involved. It connects to the `cerberus_campaigns_backend` to handle signups and donations.

## Key Features

*   **Home Page**: A landing page with a hero image, a welcome message, and an overview of the campaign.
*   **About Page**: A page with more information about the candidate.
*   **Issues Page**: A page that outlines the candidate's stance on key issues.
*   **Endorsements Page**: A page that lists the candidate's endorsements.
*   **Donate Page**: A page that allows visitors to make financial contributions to the campaign via Stripe.
*   **Signup Form**: A form that allows visitors to sign up for the campaign's email and text lists.

## Technology Stack

*   **Framework**: Flutter
*   **State Management**: Riverpod (`flutter_riverpod`)
*   **HTTP Client**: `http` package
*   **Routing**: `go_router`
*   **Styling**: `flutter_svg`
*   **URL Launcher**: `url_launcher`
*   **Stripe**: `flutter_stripe`

## Connection to Backend

*   This frontend connects to the `cerberus_campaigns_backend`.
*   The base URL for the backend API is configured in `lib/src/widgets/signup_form.dart` and `lib/src/widgets/donation_widget.dart`.

## Project Structure

*   `lib/`: Main application Dart code.
    *   `main.dart`: Entry point of the application, sets up GoRouter.
    *   `src/`: Core application logic and UI.
        *   `pages/`: UI for different pages/screens (e.g., `home_page.dart`, `donate_page.dart`).
        *   `widgets/`: Reusable UI components (e.g., `common_app_bar.dart`, `footer.dart`).
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
    cd <repository_directory>/emmons_frontend
    ```

3.  **Get dependencies:**
    ```bash
    flutter pub get
    ```

## Running the Application

1.  **Ensure Backend is Running:**
    The `cerberus_campaigns_backend` must be running and accessible at the URL configured in the frontend.

2.  **Run the application (web):**
    ```bash
    flutter run -d chrome
    ```
    This will launch the application in a Chrome browser. You can replace `chrome` with other supported browsers.

## Building for Deployment (Web)

To create a release build for the web:
```bash
flutter build web
```
The output will be placed in the `build/web` directory. These files can then be deployed to any static web hosting service.