# GCP Deployment Guide for Cerberus

This document provides a step-by-step guide for deploying the Cerberus application suite to Google Cloud Platform (GCP). It is based on the architecture and refactoring work outlined in `GCP_PLAN.md` and the progress tracked in `PROGRESS_TRACKER.md`.

## Introduction

The Cerberus platform has been refactored to align with modern cloud-native principles. The backend service (`cerberus_universal_backend`) is now a containerized Flask application designed for serverless deployment on Cloud Run. It connects to a managed Cloud SQL database and uses Secret Manager for secrets.

This guide outlines the manual steps required to set up the GCP environment. Once these steps are completed, the CI/CD pipeline defined in `cloudbuild.yaml` will automate the deployment process.

## Prerequisites

*   **Google Cloud Project**: You must have a GCP project with billing enabled.
*   **Google Cloud SDK**: The `gcloud` command-line tool must be installed and configured on your local machine.
*   **Permissions**: You must have the necessary IAM permissions to create and manage Cloud SQL, Secret Manager, and Cloud Build resources.

## Step 1: Set Up Cloud SQL for PostgreSQL

1.  **Create a Cloud SQL Instance**:
    *   Navigate to the Cloud SQL section of the GCP Console.
    *   Click "Create Instance" and choose "PostgreSQL".
    *   Provide an instance ID (e.g., `cerberus-db`).
    *   Set a strong password for the `postgres` user.
    *   Choose the desired region and zone.
    *   Under "Connectivity", select "Private IP".
    *   Enable the **PostGIS** extension.
    *   Click "Create Instance".

2.  **Create a Database**:
    *   Once the instance is created, navigate to the "Databases" tab.
    *   Click "Create database" and provide a name (e.g., `cerberus_db`).

## Step 2: Set Up Secret Manager

1.  **Enable the Secret Manager API**:
    *   Navigate to the "APIs & Services" > "Library" section of the GCP Console.
    *   Search for "Secret Manager API" and enable it.

2.  **Create Secrets**:
    *   Navigate to the Secret Manager section of the GCP Console.
    *   Create the following secrets, providing the appropriate values:
        *   `DB_USER`: The username for your Cloud SQL database (e.g., `postgres`).
        *   `DB_PASS`: The password for your Cloud SQL database.
        *   `DB_NAME`: The name of your Cloud SQL database (e.g., `cerberus_db`).
        *   `DB_CONNECTION_NAME`: The connection name of your Cloud SQL instance. You can find this on the instance details page.
        *   `SECRET_KEY`: A strong, unique secret key for Flask session management.
        *   `PGCRYPTO_SECRET_KEY`: A strong, unique secret key for database encryption.
        *   `STRIPE_SECRET_KEY`: Your Stripe secret key.
        *   `STRIPE_WEBHOOK_SECRET`: Your Stripe webhook secret.
        *   `WEBHOOK_SECRET_KEY`: A secret key for securing your application's webhooks.

3.  **Grant Access to Cloud Build**:
    *   Navigate to the IAM section of the GCP Console.
    *   Find the service account for Cloud Build (it will have a name like `[PROJECT_NUMBER]@cloudbuild.gserviceaccount.com`).
    *   Grant this service account the "Secret Manager Secret Accessor" role.

## Step 3: Configure Cloud Build Triggers

1.  **Connect Your Repository**:
    *   Navigate to the Cloud Build section of the GCP Console.
    *   Go to the "Triggers" page and click "Connect repository".
    *   Select your source code repository (e.g., GitHub) and follow the instructions to authenticate.

2.  **Create a Trigger for the Backend**:
    *   Click "Create trigger".
    *   Provide a name (e.g., `cerberus-backend-deploy`).
    *   Select the event that will trigger the build (e.g., "Push to a branch").
    *   Select your repository and the branch you want to deploy from (e.g., `main`).
    *   Under "Build configuration", select "Cloud Build configuration file (yaml or json)".
    *   Set the location of the `cloudbuild.yaml` file (it should be at the root of the repository).
    *   Under "Included files filter", add `cerberus_universal_backend/**` to ensure the trigger only runs when backend files are changed.
    *   Click "Create".

## Step 4: Run the CI/CD Pipeline

Once the trigger is configured, the CI/CD pipeline will automatically run whenever you push a change to the specified branch. You can also manually run the trigger from the Cloud Build console.

The pipeline will:
1.  Run tests.
2.  Build the Docker image.
3.  Push the image to Artifact Registry.
4.  Run database migrations.
5.  Deploy the service to Cloud Run.

## Step 5: Verify the Deployment

1.  **Check the Cloud Run Service**:
    *   Navigate to the Cloud Run section of the GCP Console.
    *   You should see the `cerberus-backend` service running.
    *   Click on the service to see its details, including the URL.

2.  **Test the API**:
    *   You can use a tool like `curl` or Postman to send requests to the service's URL.
    *   Check the `/health` endpoint to verify that the service is healthy.
