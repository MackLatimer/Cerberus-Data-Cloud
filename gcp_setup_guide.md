# GCP Setup Guide for Cerberus-Data-Cloud (Google Cloud Console)

This guide provides step-by-step instructions for provisioning the necessary Google Cloud Platform infrastructure to deploy and run the Cerberus-Data-Cloud project using the Google Cloud Console.

---

### 1. Prerequisites

*   A Google Cloud Project has been created.
*   You have access to the Google Cloud Console.
*   Billing is enabled for the project.

### 2. Enable Required APIs

1.  Open the [API Library](https://console.cloud.google.com/apis/library) in the Google Cloud Console.
2.  Search for and enable the following APIs one by one:
    *   Cloud Run API
    *   Cloud SQL Admin API
    *   Artifact Registry API
    *   Secret Manager API
    *   Cloud Build API

### 3. Set up Cloud SQL for PostgreSQL

1.  Go to the [Cloud SQL Instances](https://console.cloud.google.com/sql/instances) page.
2.  Click **Create Instance**.
3.  Choose **PostgreSQL**.
4.  Enter an **Instance ID** (e.g., `cerberus-db`).
5.  Enter a **Password** for the `postgres` user or create a new user.
6.  Choose the **Database version**, **Region**, and other settings.
7.  Under **Machine type and storage**, select a suitable machine type (e.g., 2 vCPU, 4 GB RAM) and storage size (e.g., 20 GB).
8.  Click **Create Instance**.
9.  Once the instance is created, go to the **Databases** tab and click **Create database** to create the primary application database (e.g., `cerberus_db`).
10. Go to the **Users** tab and click **Create user account** to create a dedicated user (e.g., `cerberus_user`).

### 4. Configure Secret Manager

1.  Go to the [Secret Manager](https://console.cloud.google.com/security/secret-manager) page.
2.  Click **Create Secret**.
3.  Enter a **Name** for the secret (e.g., `cerberus-db-password`).
4.  Enter the database password in the **Secret value** field.
5.  Click **Create Secret**.
6.  Repeat the process to create a secret for the Stripe API key (e.g., `stripe-api-key`).

### 5. Create an Artifact Registry Repository

1.  Go to the [Artifact Registry](https://console.cloud.google.com/artifacts) page.
2.  Click **Create Repository**.
3.  Enter a **Repository name** (e.g., `cerberus-backend-repo`).
4.  Select **Docker** as the format.
5.  Choose the **Region** where the repository will be located.
6.  Click **Create**.

### 6. Set up Firebase for Frontend Hosting

1.  Go to the [Firebase Console](https://console.firebase.google.com/).
2.  Click **Add project** and select your existing GCP project.
3.  Follow the on-screen instructions to set up Firebase.
4.  In your local project, install the Firebase CLI and run `firebase init hosting`.
5.  When prompted, select your Firebase project.
6.  Configure your `firebase.json` file as needed. For this project, you will need to set up rewrites for both `cerberus_frontend` and the multi-site `universal_campaign_frontend`.

    ```json
    {
      "hosting": {
        "public": "build/web",
        "ignore": [
          "firebase.json",
          "**/.*",
          "**/node_modules/**"
        ],
        "rewrites": [
          {
            "source": "/cerberus/**",
            "destination": "/cerberus/index.html"
          },
          {
            "source": "/campaigns/**",
            "destination": "/campaigns/index.html"
          }
        ]
      }
    }
    ```

### 7. Configure IAM & Service Accounts

1.  Go to the [IAM & Admin](https://console.cloud.google.com/iam-admin/iam) page.
2.  Find the default **Compute Engine service account** (`[PROJECT_NUMBER]-compute@developer.gserviceaccount.com`).
3.  Click the **pencil icon** to edit the service account's roles.
4.  Add the following roles:
    *   **Cloud SQL Client**
    *   **Secret Manager Secret Accessor**
    *   **Cloud Run Admin** (This role is required for Cloud Build to deploy to Cloud Run)
5.  Click **Save**.

### 8. Set up Cloud Build for CI/CD

1.  Go to the [Cloud Build Triggers](https://console.cloud.google.com/cloud-build/triggers) page.
2.  Click **Connect repository** and follow the instructions to connect your Git repository.
3.  Click **Create trigger**.
4.  **Trigger for `cerberus_universal_backend`:**
    *   **Name:** `build-and-deploy-backend`
    *   **Event:** Push to a branch
    *   **Repository:** Your connected repository
    *   **Branch:** `main`
    *   **Configuration:** Cloud Build configuration file (`cloudbuild.yaml`)
    *   **Location:** `/cerberus_universal_backend/cloudbuild.yaml`
    *   Click **Create**.
5.  **Trigger for frontends:**
    *   **Name:** `build-and-deploy-frontends`
    *   **Event:** Push to a branch
    *   **Repository:** Your connected repository
    *   **Branch:** `main`
    *   **Configuration:** Cloud Build configuration file (`cloudbuild.yaml`)
    *   **Location:** `/cloudbuild.yaml` (in the root directory)
    *   Click **Create**.
