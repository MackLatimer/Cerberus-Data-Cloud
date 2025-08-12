# Cerberus Data Cloud: Project Issues

This document outlines the existing problems, architectural flaws, security vulnerabilities, and missing components identified in the Cerberus-Data-Cloud project.

## 1. Critical Security Flaws

### 1.1. Hardcoded Stripe Publishable Key

*   **File:** `cerberus_frontend/lib/main.dart`
*   **Description:** The Stripe publishable key is hardcoded directly in the frontend code. While publishable keys are meant to be public, this is a bad practice. It makes it difficult to manage keys for different environments (e.g., development, production) and increases the risk of accidentally exposing a live key in a development build.
*   **Recommendation:** Load the Stripe publishable key from a configuration file or an environment variable.

### 1.2. Hardcoded Secret Key in Testing Configuration

*   **File:** `cerberus_universal_backend/app/config.py`
*   **Description:** The `TestingConfig` class in the backend has a hardcoded `SECRET_KEY`. If this configuration is ever used in a non-testing environment, it could expose the application to security risks.
*   **Recommendation:** Use a different mechanism for handling secrets in the testing environment, such as loading them from a separate, untracked configuration file or using a tool like `python-dotenv`.

## 2. Architectural Violations

No major architectural violations were found. The project is well-structured and follows the intended three-part architecture.

## 3. Reliability Bugs

### 3.1. Unreliable Configuration Loading in `universal_campaign_frontend`

*   **File:** `universal_campaign_frontend/lib/config/config_loader.dart`
*   **Description:** The configuration loading mechanism relies on the browser's `window.location.hostname`. This can be unreliable in certain deployment scenarios, such as when the application is running behind a proxy or a load balancer. Additionally, the configuration is hardcoded in the `campaigns.dart` file, making it inflexible.
*   **Recommendation:** Decouple the configuration loading from the hostname. Consider loading the configuration from an external source, such as a JSON file or an API endpoint, and pass the campaign ID as a parameter or in the path.

## 4. Performance Bottlenecks

### 4.1. N+1 Query Problem in `list_persons_via_portal`

*   **File:** `cerberus_universal_backend/app/routes/voters.py`
*   **Description:** The `list_persons_via_portal` function suffers from the N+1 query problem. It retrieves a list of persons and then executes additional queries for each person to fetch their email and phone numbers. This can lead to a large number of database queries and slow down the API.
*   **Recommendation:** Use SQLAlchemy's `joinedload` or `selectinload` options to eager-load the related `PersonEmail` and `PersonPhone` objects in a single query.

### 4.2. Inefficient Data Handling in CSV Upload

*   **File:** `cerberus_universal_backend/app/routes/voters.py`
*   **Description:** The `upload_persons` function reads the entire CSV file into memory, which can be inefficient for large files.
*   **Recommendation:** Process the CSV file line by line to avoid loading the entire file into memory.

## 5. Missing Components and Features

### 5.1. Missing `.dockerignore` file in `cerberus_universal_backend`

*   **File:** `cerberus_universal_backend/.dockerignore` (missing)
*   **Description:** The `cerberus_universal_backend` directory is missing a `.dockerignore` file. This can lead to unnecessarily large Docker images and potential security risks.
*   **Recommendation:** Create a `.dockerignore` file to exclude unnecessary files and directories from the Docker build context.

### 5.2. Lack of Input Validation and Sanitization in CSV Upload

*   **File:** `cerberus_universal_backend/app/routes/voters.py`
*   **Description:** The `upload_persons` function does not perform adequate input validation and sanitization on the data from the CSV file. This could lead to data integrity issues and potential errors.
*   **Recommendation:** Implement robust validation and sanitization for all data coming from the CSV file.
