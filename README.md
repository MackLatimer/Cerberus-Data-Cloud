# Test Scraper (`test_scraper.py`)

This document provides instructions on how to run the `test_scraper.py` script.
The `test_scraper.py` script contains unit tests for the `scraper.py` module, which is responsible for scraping agenda data from municipality websites.

## Prerequisites

Before running the tests, ensure you have the following installed:

- Python 3.x
- pip (Python package installer)

## Setting up the Environment

1.  **Clone the repository (if you haven't already):**
    ```bash
    git clone <repository_url>
    cd <repository_directory>
    ```
    *(Replace `<repository_url>` and `<repository_directory>` with the actual URL and directory name.)*

2.  **Install dependencies:**
    Navigate to the root directory of the project. The backend dependencies are defined in `cerberus_report_backend/requirements.txt`. Run the following command to install them:
    ```bash
    pip install -r cerberus_report_backend/requirements.txt
    ```

## Running the Tests

Once the environment is set up, you can run the tests using the following commands from the root directory of the project:

```bash
python -m unittest cerberus_report_backend/test_scraper.py
```
(You can also run `python -m unittest cerberus_report_backend/test_notification_sender.py` for the notification sender tests).

## Configuration

The `scraper.py` script, which `test_scraper.py` tests, relies on the `DATABASE_URL` environment variable for connecting to the database.

For the purpose of `test_scraper.py`, the database connection (`scraper.get_db_connection`) is mocked. Therefore, you **do not** need to set up the `DATABASE_URL` environment variable specifically to run these unit tests.

However, if you intend to run the main `scraper.py` script or other parts of the application that depend on a database connection, ensure that `DATABASE_URL` is properly configured in your environment. (Note: `api.py` and `notification_sender.py` use individual Google Cloud SQL connector environment variables instead of `DATABASE_URL`).

## Interpreting Test Results

After running the tests, `unittest` will provide output indicating the status of each test:

-   **OK:** All tests passed successfully. You'll typically see a message like `OK` at the end, along with the number of tests run.
-   **FAILURES/ERRORS:** If any tests fail or encounter errors, `unittest` will detail them. It will show which tests failed, the reason for failure (e.g., assertion errors), and a traceback for errors.

Example of a successful output:

```
.
----------------------------------------------------------------------
Ran 1 test in 0.001s

OK
```
*(The number of dots usually corresponds to the number of tests executed.)*

If there are failures, the output will look something like this (example):

```
F.
======================================================================
FAIL: test_example_failure (test_module.TestClassName)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/path/to/your/test_module.py", line XX, in test_example_failure
    self.assertEqual(1, 2)
AssertionError: 1 != 2

----------------------------------------------------------------------
Ran 2 tests in 0.002s

FAILED (failures=1)
```
Pay attention to the messages to understand which specific tests did not pass and why.

---

# Email Notification Feature (`notification_sender.py`)

The `notification_sender.py` script is responsible for sending email notifications to users who have subscribed to updates based on specific filter criteria. It queries the database for new agenda items matching user subscriptions and uses SendGrid to dispatch emails.

## Environment Variables

For `notification_sender.py` to function correctly, the following environment variables must be set:

-   **`SENDGRID_API_KEY`**: Your API key for the SendGrid service. This is required to send emails.
-   **`SENDER_EMAIL`**: The email address from which notifications will be sent (e.g., `notifications@yourdomain.com`). This must be a verified sender in SendGrid.
-   **`INSTANCE_CONNECTION_NAME`**: The connection name for your Google Cloud SQL instance (e.g., `your-project:your-region:your-instance`).
-   **`DB_USER`**: The username for the database connection.
-   **`DB_PASS`**: The password for the database user.
-   **`DB_NAME`**: The name of the database.
-   **`APP_BASE_URL`**: (Optional) The base URL of your frontend application (e.g., `https://www.yourapp.com`). This defaults to `http://localhost:3000` if not set. It's used for constructing links back to your application in the notification emails.

## Scheduling `notification_sender.py`

The `notification_sender.py` script needs to be run periodically to check for new agenda items and send out notifications. Here are a few common ways to schedule its execution:

1.  **Cron Job:**
    If you have a server (e.g., a Compute Engine VM), you can set up a cron job.
    Example cron entry to run the script daily at 3 AM:
    ```cron
    0 3 * * * /usr/bin/python3 /path/to/your/project/cerberus_report_backend/notification_sender.py >> /path/to/your/project/logs/notification_sender.log 2>&1
    ```
    Ensure the Python interpreter path and script path are correct. Logging output is recommended.

2.  **Google Cloud Scheduler & Cloud Run/Cloud Functions:**
    A more serverless approach is to use Google Cloud Scheduler to trigger a job.
    -   **Cloud Run:** Package your Python application (including `notification_sender.py`) into a Docker container. Create a Cloud Run job (not a service) that executes `python notification_sender.py`. Trigger this job using Cloud Scheduler.
    -   **Cloud Functions (2nd gen):** Deploy a Python Cloud Function that wraps the logic of `notification_sender.py`. Trigger this function using Cloud Scheduler. This is suitable if the script's execution time fits within Cloud Function limits.

    This approach benefits from managed execution and easier integration with other Google Cloud services.

## Dependencies

The notification feature introduced the following major dependency:
-   `sendgrid`: This Python library is used to interact with the SendGrid API for sending emails. It has been added to the `cerberus_report_backend/requirements.txt` file.

Remember to install or update dependencies if you are deploying this feature:
```bash
pip install -r cerberus_report_backend/requirements.txt
```

Unit tests for this feature can be run with:
```bash
python -m unittest cerberus_report_backend/test_notification_sender.py
```
