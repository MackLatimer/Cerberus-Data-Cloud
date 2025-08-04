# Cerberus Report Backend

## Overview

This directory contains the Python backend application for the Cerberus Report. This backend is responsible for scraping public municipal agenda items, storing them in a database, and providing an API for the `cerberus_frontend` to consume. It also includes a notification system to alert users about new agenda items that match their interests.

## Features

*   **API**: A Flask-based API that provides endpoints for searching and retrieving agenda items, as well as managing user subscriptions.
*   **Scraper**: A script that scrapes agenda data from various municipal websites. The scraper is designed to be extensible, with a dispatch table that allows for different scraper functions to be used for different types of websites.
*   **Notification Sender**: A script that sends email notifications to users who have subscribed to receive updates on new agenda items. The notification sender uses the SendGrid API to send emails.

## Technology Stack

*   **Framework**: Flask
*   **Database**: PostgreSQL
*   **Libraries**:
    *   `requests`: For making HTTP requests to municipal websites.
    *   `beautifulsoup4`: For parsing HTML and XML.
    *   `pdfplumber`: For extracting text from PDF files.
    *   `Flask-CORS`: For handling Cross-Origin Resource Sharing.
    *   `gunicorn`: For running the Flask application in production.
    *   `cloud-sql-python-connector`: For connecting to a Google Cloud SQL database.
    *   `pg8000`: A Pure-Python PostgreSQL driver.
    *   `sendgrid`: For sending emails via the SendGrid API.

## Project Structure

*   `api.py`: The main Flask application file. This file defines the API endpoints and handles all incoming requests.
*   `scraper.py`: The script for scraping agenda data from municipal websites.
*   `notification_sender.py`: The script for sending email notifications to subscribers.
*   `requirements.txt`: A list of the Python packages required to run the backend.
*   `schema.sql`: The SQL schema for the database.

## API Endpoints

*   **GET /search**: Searches for agenda items based on a keyword, municipality, date range, and other filters.
*   **POST /subscribe**: Creates a new subscription for a user to receive email notifications about new agenda items.
*   **POST /webhook/order_canceled**: A webhook for handling canceled subscriptions.
*   **POST /webhook/order_renewed**: A webhook for handling renewed subscriptions.
*   **GET /municipalities**: Returns a list of the municipalities that are currently being scraped.
*   **GET /categories**: Returns a list of the available agenda item categories.
*   **GET /headings**: Returns a list of the available agenda item headings.
*   **GET /test_db**: A test endpoint for checking the database connection.
*   **GET /**: A health check endpoint.

## Setup and Installation

1.  **Clone the repository (if you haven't already):**
    ```bash
    git clone <repository_url>
    cd <repository_directory>/cerberus_report_backend
    ```

2.  **Create and activate a virtual environment:**
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate
    ```

3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Configure environment variables:**
    *   You will need to set the following environment variables:
        *   `INSTANCE_CONNECTION_NAME`: The connection name of your Google Cloud SQL instance.
        *   `DB_USER`: The username for your database.
        *   `DB_PASS`: The password for your database.
        *   `DB_NAME`: The name of your database.
        *   `SENDGRID_API_KEY`: Your SendGrid API key.
        *   `SENDER_EMAIL`: The email address that you want to send notifications from.
        *   `APP_BASE_URL`: The base URL of your application.

5.  **Initialize the database:**
    *   You will need to create a PostgreSQL database and then run the `schema.sql` file to create the necessary tables.

## Running the Application

*   **API**: To run the API, you can use the following command:
    ```bash
    gunicorn --bind :8080 api:app
    ```
*   **Scraper**: To run the scraper, you can use the following command:
    ```bash
    python scraper.py
    ```
*   **Notification Sender**: To run the notification sender, you can use the following command:
    ```bash
    python notification_sender.py
    ```