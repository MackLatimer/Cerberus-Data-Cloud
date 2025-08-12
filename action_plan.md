# Cerberus Data Cloud: Action Plan

This document provides a comprehensive, step-by-step action plan to fix all identified issues in the Cerberus-Data-Cloud project and prepare it for a robust deployment on Google Cloud Platform.

## 1. Target GCP Architecture

We propose the following target architecture for deploying the Cerberus-Data-Cloud project on GCP:

*   **`cerberus_universal_backend`:**
    *   **Compute:** Cloud Run - A serverless platform to run the containerized Flask application. It automatically scales up and down, and you only pay for the resources you use.
    *   **Database:** Cloud SQL for PostgreSQL - A fully managed relational database service that is easy to set up, maintain, and administer.
    *   **Secrets Management:** Secret Manager - To securely store and manage all secrets, including database credentials, API keys, and the Flask secret key.

*   **`cerberus_frontend` and `universal_campaign_frontend`:**
    *   **Hosting:** Firebase Hosting - A fast, secure, and reliable hosting service for web applications. It provides a global CDN, SSL certificates, and easy integration with other Firebase and GCP services.

*   **CI/CD:**
    *   **Continuous Integration/Continuous Deployment:** Cloud Build - To automate the process of building, testing, and deploying the applications to Cloud Run and Firebase Hosting.

## 2. Prioritized Task List

### Phase 1: Security and Configuration

#### Task 1.1: Remediate Hardcoded Secrets

*   **Definition of Done:** All hardcoded secrets are removed from the codebase and stored in Secret Manager. The application retrieves secrets from Secret Manager at runtime.
*   **Files to Modify:**
    *   `cerberus_frontend/lib/main.dart`
    *   `cerberus_universal_backend/app/config.py`
*   **Action:**
    1.  **Backend:** Modify `cerberus_universal_backend/app/config.py` to use the Google Cloud Secret Manager client library to fetch secrets. Remove the hardcoded secret key from the `TestingConfig`.
    2.  **Frontend:** In `cerberus_frontend/lib/main.dart`, remove the hardcoded Stripe publishable key. Instead, load the key from a configuration file or an environment variable that is populated by the CI/CD pipeline.

#### Task 1.2: Create `.dockerignore` for Backend

*   **Definition of Done:** A `.dockerignore` file is created in the `cerberus_universal_backend` directory to prevent unnecessary files from being included in the Docker image.
*   **Files to Create:**
    *   `cerberus_universal_backend/.dockerignore`
*   **Action:** Create a `.dockerignore` file with the following content:

```
.git
.gitignore
.pytest_cache
__pycache__/
*.pyc
*.pyo
*.pyd
.env
```

### Phase 2: Backend Refactoring

#### Task 2.1: Optimize Database Queries

*   **Definition of Done:** The N+1 query problem in the `list_persons_via_portal` function is resolved.
*   **Files to Modify:**
    *   `cerberus_universal_backend/app/routes/voters.py`
*   **Action:** In the `list_persons_via_portal` function, use SQLAlchemy's `joinedload` or `selectinload` to eager-load the `PersonEmail` and `PersonPhone` relationships.

#### Task 2.2: Improve CSV Upload Performance and Reliability

*   **Definition of Done:** The `upload_persons` function is refactored to process CSV files line by line and includes robust input validation and sanitization.
*   **Files to Modify:**
    *   `cerberus_universal_backend/app/routes/voters.py`
*   **Action:**
    1.  Modify the `upload_persons` function to read the CSV file line by line instead of loading the entire file into memory.
    2.  Implement comprehensive input validation and sanitization for each field in the CSV file.

### Phase 3: Frontend Refactoring

#### Task 3.1: Refactor `universal_campaign_frontend` Configuration

*   **Definition of Done:** The configuration loading mechanism in the `universal_campaign_frontend` is decoupled from the hostname and is more flexible.
*   **Files to Modify:**
    *   `universal_campaign_frontend/lib/config/config_loader.dart`
    *   `universal_campaign_frontend/lib/main.dart`
*   **Action:**
    1.  Modify the `getCampaignConfig` function to accept a campaign identifier as a parameter.
    2.  Instead of relying on the hostname, pass the campaign identifier in the URL path or as a query parameter.
    3.  Consider moving the campaign configurations to a separate JSON file or an API endpoint to make it easier to manage.

### Phase 4: Deployment and CI/CD

#### Task 4.1: Set Up GCP Infrastructure

*   **Definition of Done:** All necessary GCP resources are created and configured.
*   **Action:**
    1.  Create a new GCP project.
    2.  Set up a Cloud SQL for PostgreSQL instance.
    3.  Create secrets in Secret Manager for all sensitive data.
    4.  Create a Firebase project and set up Firebase Hosting.

#### Task 4.2: Implement CI/CD Pipelines

*   **Definition of Done:** CI/CD pipelines are created in Cloud Build to automate the building, testing, and deployment of all three applications.
*   **Files to Create:**
    *   `cloudbuild.yaml` (in the root directory)
*   **Action:**
    1.  Create a `cloudbuild.yaml` file that defines the build steps for each application.
    2.  The backend pipeline should build the Docker image, push it to Google Container Registry, and deploy it to Cloud Run.
    3.  The frontend pipelines should build the Flutter web applications and deploy them to Firebase Hosting.
