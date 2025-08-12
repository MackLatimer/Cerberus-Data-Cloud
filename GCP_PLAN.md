# GCP Migration and Modernization Proposal: Cerberus Platform

This document outlines a strategic plan for migrating the Cerberus platform to a modern, scalable, and secure architecture on Google Cloud Platform. The proposal is based on an analysis of the existing codebase, architectural documents, and identified problems.

## 1. Recommended GCP Services

To meet the goals of a serverless-first, managed, and cost-effective architecture, we recommend a suite of GCP services that seamlessly integrate and provide a robust foundation for the Cerberus application suite.

### Core Application Hosting: Google Cloud Run

*   **Recommendation**: The primary Flask backend (`cerberus_universal_backend`) and the two Flutter frontend applications should be deployed as services on **Google Cloud Run**.
*   **Justification**:
    *   **Serverless & Managed**: Cloud Run is a fully managed platform that abstracts away all infrastructure management. You only need to provide a container image, and Google handles the provisioning, scaling, and server maintenance.
    *   **Scalability**: It automatically scales the number of container instances up or down based on incoming traffic, including scaling down to zero. This ensures high availability during peak loads and cost savings during idle periods.
    *   **Cost-Effectiveness**: The pay-per-use model means you are only billed for the CPU and memory consumed while your code is executing. This is significantly more cost-effective than running VMs 24/7.
    *   **Direct Integration**: Cloud Run has built-in integrations with other key GCP services like Cloud SQL, Secret Manager, and Cloud Build.

### Database: Google Cloud SQL for PostgreSQL

*   **Recommendation**: The existing PostgreSQL database should be migrated to **Google Cloud SQL for PostgreSQL**.
*   **Justification**:
    *   **Fully Managed**: Cloud SQL automates tedious database administration tasks such as backups, replication, patching, and updates, freeing up developer time.
    *   **High Availability & Reliability**: It offers a high-availability configuration with automatic failover to a standby instance, ensuring the database remains operational.
    *   **Security**: Communication with Cloud SQL is secured using the Cloud SQL Auth Proxy, which provides IAM-based database authorization and automatic encryption in transit. This is the recommended and most secure way for Cloud Run services to connect to a database.
    *   **Compatibility**: As the project already uses PostgreSQL with PostGIS, the migration to Cloud SQL will be straightforward with minimal application code changes.

### Secrets Management: Google Secret Manager

*   **Recommendation**: All sensitive data, including database credentials, API keys (Stripe, etc.), and the application `SECRET_KEY`, must be stored in **Google Secret Manager**.
*   **Justification**:
    *   **Centralized & Secure**: It provides a single, secure, and auditable place to store and manage secrets. This eliminates the dangerous practice of hardcoding secrets in source code or storing them in `.env` files.
    *   **IAM Integration**: Access to secrets is controlled through GCP's Identity and Access Management (IAM), allowing you to grant specific permissions to specific services (e.g., allowing only the Cloud Run service to access the database password).
    *   **Versioning**: Secret Manager supports versioning, making it easy to rotate secrets without needing to redeploy the application.

### Container Storage: Google Artifact Registry

*   **Recommendation**: All Docker container images for the backend and frontends should be stored in **Google Artifact Registry**.
*   **Justification**:
    *   **Secure Private Registry**: Artifact Registry provides a secure, private, and managed repository for your container images within your GCP environment.
    *   **Vulnerability Scanning**: It can automatically scan container images for known security vulnerabilities, adding a critical layer of security to your supply chain.
    *   **Regionalization**: Repositories can be created in the same region as your Cloud Run services, reducing image pull latency and improving deployment speed.

### CI/CD: Google Cloud Build

*   **Recommendation**: Continue using **Google Cloud Build** as the CI/CD platform, but with an optimized and more granular configuration.
*   **Justification**:
    *   **Managed & Serverless**: Cloud Build is a fully managed CI/CD service that runs builds in a serverless environment, so you don't need to manage your own build servers.
    *   **Deep GCP Integration**: It seamlessly integrates with source control (like GitHub), Artifact Registry, and Cloud Run, making it the natural choice for automating builds and deployments on GCP.
    *   **Declarative Pipelines**: Build pipelines are defined in a simple YAML file (`cloudbuild.yaml`), allowing you to manage your CI/CD process as code.

## 2. Containerization Plan

A robust containerization strategy is essential for security, reproducibility, and efficiency. We will replace the existing `Dockerfile` with an optimized, multi-stage `Dockerfile` that adheres to modern best practices.

### Proposed `Dockerfile` for `cerberus_universal_backend`

```dockerfile
# ---- Base Stage: Common foundation ----
# Use a specific, LTS version of Python for stability and security.
# slim-bullseye is a Debian-based image that is small and secure.
FROM python:3.9.18-slim-bullseye as base

# Set environment variables to optimize Python and Gunicorn execution
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # PORT is automatically supplied by Cloud Run, default to 8080 for local testing
    PORT=8080

WORKDIR /app

# ---- Builder Stage: Install dependencies ----
# This stage compiles dependencies, including those with C extensions.
FROM base as builder

# Install build-time OS dependencies needed for Python packages.
# - build-essential: for compiling C extensions.
# - libpq-dev: for psycopg2 (PostgreSQL driver).
# - libgeos-dev: for GeoAlchemy2 (geospatial data).
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libgeos-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a virtual environment to isolate dependencies
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- Final Stage: Production image ----
# This stage creates the final, lightweight, and secure runtime image.
FROM base as final

# Install only the required runtime OS dependencies.
# - libpq5: runtime library for psycopg2.
# - libgeos-c1v5: runtime library for GeoAlchemy2.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpq5 \
    libgeos-c1v5 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-privileged user and group to run the application
RUN groupadd -r appgroup && useradd --no-log-init -r -g appgroup appuser

# Copy the virtual environment from the builder stage
COPY --from=builder /venv /venv

# Copy only the necessary application code
COPY --chown=appuser:appgroup app/ ./app/
COPY --chown=appuser:appgroup run.py .
COPY --chown=appuser:appgroup migrations/ ./migrations/
COPY --chown=appuser:appgroup alembic.ini .

# Switch to the non-privileged user
USER appuser

# Set PATH to use the virtual environment
ENV PATH="/venv/bin:$PATH"

# Expose the port the application will listen on
EXPOSE 8080

# Start the Gunicorn server.
# `exec` is used to ensure Gunicorn runs as PID 1 and receives signals correctly.
# The number of workers and threads is optimized for a Cloud Run environment.
# --timeout 0 disables Gunicorn's timeout to let Cloud Run manage request timeouts.
CMD exec gunicorn --bind "0.0.0.0:${PORT}" --workers 1 --threads 8 --timeout 0 "run:app"
```

### Key Improvements and Justifications

1.  **Multi-Stage Build**: The `Dockerfile` uses a `builder` stage and a `final` stage.
    *   **Benefit**: The `builder` stage installs build tools (`build-essential`, etc.) and compiles dependencies. The `final` stage only copies the necessary runtime libraries and the compiled Python environment. This results in a significantly smaller and more secure production image, as it doesn't contain build tools or other unnecessary files.

2.  **Minimal Base Image**: We use `python:3.9.18-slim-bullseye`, a minimal and secure base image. Pinning to a specific version ensures deterministic and reproducible builds.

3.  **Principle of Least Privilege**: The application is run by a non-privileged user (`appuser`).
    *   **Benefit**: This is a critical security best practice. If a vulnerability were to be exploited in the application, the attacker would have limited permissions within the container, preventing them from gaining root access.

4.  **Optimized Dependency Management**:
    *   **OS Packages**: We separate build-time (`libpq-dev`, `libgeos-dev`) from runtime (`libpq5`, `libgeos-c1v5`) OS dependencies, installing only what's needed in the final image.
    *   **Python Packages**: Dependencies are installed into a virtual environment (`/venv`), which is a best practice for isolation.

5.  **Selective Code Copying**: Instead of `COPY . /app`, we now explicitly copy only the required source files (`app/`, `run.py`, `migrations/`, `alembic.ini`).
    *   **Benefit**: This prevents development artifacts (like tests, `.git` folder, local `venv` folders, etc.) from being included in the image, reducing its size and attack surface. It also improves Docker's layer caching, speeding up builds.

6.  **Gunicorn Configuration for Cloud Run**: The `CMD` is optimized for a serverless environment like Cloud Run.
    *   **Benefit**: Using a single worker with multiple threads (`--workers 1 --threads 8`) is the recommended configuration for Cloud Run. Concurrency is handled by Cloud Run's ability to spin up multiple container instances, while threads handle concurrent requests within a single instance. Using `exec` ensures proper signal handling.

## 3. CI/CD Pipeline on Google Cloud Build

We will enhance the existing CI/CD pipeline defined in `cloudbuild.yaml` to be more efficient, secure, and automated. The goal is to create a robust pipeline that tests, builds, and deploys the `cerberus_universal_backend` service reliably.

### Trigger Strategy for Monorepo

To avoid unnecessary builds, we will configure separate Cloud Build triggers for each service in the monorepo (`cerberus_universal_backend`, `cerberus_frontend`, etc.). Each trigger will be configured to only start a build when files within its specific directory are changed.

*   **Example Trigger for Backend**: A trigger for the `cerberus_universal_backend` service will be configured with the following "included files" filter:
    *   `cerberus_universal_backend/**`
*   **Benefit**: This ensures that a commit changing only the frontend code will not trigger the backend's build and deployment pipeline, saving time and compute resources.

### Proposed Pipeline Stages for Backend Service

The `cloudbuild.yaml` for the backend service will be structured with the following stages, executed in order:

1.  **Run Unit & Integration Tests**:
    *   **Action**: Use a `python` builder image to install dependencies from `requirements.txt` and `requirements-dev.txt`.
    *   **Command**: Run the test suite using `pytest`.
    *   **Purpose**: To catch regressions and bugs early. A build will fail at this stage if any test fails, preventing broken code from being deployed.

2.  **Build the Docker Image**:
    *   **Action**: Use the standard `docker` builder.
    *   **Command**: Execute `docker build` using the new, optimized `Dockerfile` located in `cerberus_universal_backend/`. The image will be tagged with the commit SHA for traceability.
    *   **Purpose**: To create the production container image.

3.  **Push to Google Artifact Registry**:
    *   **Action**: Use the `docker` builder.
    *   **Command**: Execute `docker push` to push the tagged image to the designated Artifact Registry repository.
    *   **Purpose**: To store the versioned, build artifact securely. Artifact Registry will automatically scan the pushed image for known vulnerabilities.

4.  **Apply Database Migrations**:
    *   **Action**: This is a critical step that must happen before deploying the new application code. We will use a Cloud Build step that runs the `gcloud` command-line tool to execute a one-off job or command. A more robust approach involves using a dedicated migration tool or a custom script. For this plan, we'll outline a method using a Cloud Build step that leverages the newly built container.
    *   **Command**: The step will use the just-built Docker image to run the `flask db upgrade` command. This requires the build step to have access to the database credentials, which will be securely fetched from Secret Manager.
    *   **Purpose**: To ensure the database schema is compatible with the new code *before* the application starts serving traffic.

5.  **Deploy to Cloud Run**:
    *   **Action**: Use the `gcloud` builder.
    *   **Command**: Execute `gcloud run deploy` to deploy the newly pushed image from Artifact Registry to the `cerberus-backend` Cloud Run service. The command will also pass necessary environment variables and secrets from Secret Manager.
    *   **Purpose**: To release the new version of the application. Cloud Run will perform a zero-downtime deployment, gradually shifting traffic to the new revision.

This structured pipeline ensures that each change is thoroughly tested and validated before being deployed, and the automated migration step keeps the database schema in sync with the application.

## 4. High-Level Refactoring Plan

To align the `cerberus_universal_backend` service with the 12-Factor App methodology and resolve the critical security and code quality issues, a number of refactoring efforts are required. This plan outlines the major changes needed.

### 1. Externalize Configuration and Secrets

This is the most critical step for adhering to the 12-Factor App principles. All configuration, especially secrets, must be removed from the code and supplied by the environment.

*   **Action**: Modify the Flask application's configuration loading (`app/config.py`).
    *   Remove all hardcoded values for `SECRET_KEY`, `PGCRYPTO_SECRET_KEY`, and `SQLALCHEMY_DATABASE_URI`.
    *   The application must be configured to read these values from environment variables (e.g., using `os.getenv()`).
    *   The application should fail to start if any of these required environment variables are not set. Remove default fallback values.
*   **Deployment**: In the Cloud Run deployment configuration (`cloudbuild.yaml`), these environment variables will be populated by referencing secrets stored securely in **Google Secret Manager**.

### 2. Implement JWT-Based Authentication

To fix the critical security vulnerability of unprotected endpoints, we will implement a robust authentication system using JSON Web Tokens (JWT).

*   **Action 1: Create Authentication Endpoints**:
    *   Implement a new route, `/api/v1/auth/login`, that accepts a username and password.
    *   This endpoint will validate the credentials against the `User` model in the database.
    *   Upon successful validation, it will generate a short-lived JWT containing the user's ID and role, signed with the application's `SECRET_KEY`.
*   **Action 2: Create a Protection Decorator**:
    *   Create a Python decorator (e.g., `@token_required`).
    *   This decorator will be applied to all sensitive API blueprints/routes (e.g., the entire `voters_api_bp`).
    *   It will inspect the `Authorization` header for a `Bearer` token, validate the JWT's signature and expiration, and extract the user's identity. If the token is invalid or missing, it will return a `401 Unauthorized` error.
*   **Action 3: Update Frontend**: The frontend applications will need to be updated to:
    *   Store the received JWT securely (e.g., in memory or `sessionStorage`).
    *   Include the JWT in the `Authorization` header for all subsequent API requests.

### 3. Remediate Security Vulnerabilities

The following critical vulnerabilities identified in `PROBLEMS.csv` must be addressed:

*   **SQL Injection (`agendas.py`)**:
    *   **Action**: Rewrite the `search` function to use parameterized queries with SQLAlchemy. The `keyword` from the request must be passed as a parameter to the `ilike()` function, not formatted into the string directly.
    *   **Example**: `Person.first_name.ilike(f"%{keyword}%")` becomes `Person.first_name.ilike('%' + keyword + '%')`.
*   **Insecure Webhooks (`agendas.py`)**:
    *   **Action**: Implement webhook signature verification for the `/webhook/order_canceled` and `/webhook/order_renewed` endpoints. This involves using a shared secret (stored in Secret Manager) to calculate a signature and comparing it with the signature provided in the request header.
*   **Data Encryption Bugs (`voters.py`, `donate.py`)**:
    *   **Action**: Correct the logic in the CSV upload and donation update functions to ensure that email and phone number fields are always passed through the `encrypt_data` function before being saved to the database.
*   **Upgrade Vulnerable Dependencies**:
    *   **Action**: Update `requirements.txt` to use the latest secure versions of `gunicorn` (>= 22.0.0) and `flask-cors` (>= 4.0.1).

### 4. Code Cleanup and Restructuring

To improve maintainability and reduce technical debt, the following actions should be taken:

*   **Remove Dead Code**:
    *   **Action**: Delete the entire `cerberus_campaigns_backend` directory from the repository.
*   **Centralize Security Functions**:
    *   **Action**: Create a new file, `app/utils/security.py`.
    *   Move the `encrypt_data` and `decrypt_data` functions from `donate.py` into this new file.
    *   Import and use these centralized functions wherever encryption or decryption is needed, removing the duplicated code.
*   **Fix Missing Imports**:
    *   **Action**: Add the necessary import statement for the encryption functions in `app/routes/voters.py`.

This refactoring plan will result in a more secure, robust, and maintainable application that is well-suited for a modern cloud environment.

## 5. Proposed Fixes

### Container Optimization

- Updated the root `Dockerfile` to a multi-stage build as per the plan. This includes using `python:3.9.18-slim-bullseye`, separating builder and final stages, and running as a non-root user. This change aligns the root `Dockerfile` with the `cerberus_universal_backend` `Dockerfile` and the overall containerization strategy.
