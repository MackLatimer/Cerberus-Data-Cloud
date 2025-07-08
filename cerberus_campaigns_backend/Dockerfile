# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set environment variables
# PYTHONUNBUFFERED ensures that Python output is sent straight to the terminal without being buffered first.
ENV PYTHONUNBUFFERED 1
# Set FLASK_APP to the entry point of the application
ENV FLASK_APP=run.py
# Set FLASK_ENV to production by default for Docker images
ENV FLASK_ENV=production
# The port the application will run on, matching run.py's default or environment variable.
# Cloud Run will provide its own PORT environment variable, which Gunicorn will use.
# This ENV PORT here is more of a default or for local `docker run` if $PORT isn't set.
ENV PORT=5001

# Set the working directory in the container
WORKDIR /app

# Install system dependencies that might be needed by Python packages (e.g., PostgreSQL client)
# psycopg2-binary (common for Flask/PostgreSQL) often needs libpq-dev
RUN apt-get update && apt-get install -y --no-install-recommends     libpq-dev     build-essential     && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container at /app
COPY cerberus_campaigns_backend/requirements.txt .

# Install any needed packages specified in requirements.txt
# --no-cache-dir: Disables the pip cache, which can reduce image size.
# -r requirements.txt: Installs packages from the given requirements file.
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container at /app
# This includes the 'app' directory, 'run.py', '.env.example', etc.
# Ensure the .env file is NOT copied if it contains secrets; secrets should be passed as environment variables.
COPY cerberus_campaigns_backend/ /app/

# Make port defined by $PORT (set by Cloud Run, defaults to 5001 here if not set) available
# This EXPOSE is informational; Cloud Run handles actual port mapping based on what the app listens to.
EXPOSE $PORT

# Define the command to run the application
# Using shell form for CMD allows $PORT environment variable expansion.
# Gunicorn is a production-ready WSGI server.
# --bind "0.0.0.0:$PORT": Binds Gunicorn to all network interfaces on the port specified by the $PORT environment variable (provided by Cloud Run).
# "run:app": Tells Gunicorn to use the 'app' Flask application instance located in the 'run.py' file.
# The number of workers can be tuned. A common recommendation is (2 * number_of_cores) + 1.
# For Cloud Run, typically start with a small number like 2-4 workers.
# The FLASK_ENV=production (set as ENV in this Dockerfile) should make create_app() load ProductionConfig.
# Logging options for Gunicorn:
# --access-logfile - : Send access logs to stdout
# --error-logfile - : Send error logs to stderr
# These are good for Cloud Run, which collects logs from stdout/stderr.
CMD gunicorn --bind "0.0.0.0:$PORT" --workers 4 --access-logfile - --error-logfile - run:app