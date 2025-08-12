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
COPY cerberus_universal_backend/requirements.txt .
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

# Copy only the necessary application code from the sub-directory
COPY --chown=appuser:appgroup cerberus_universal_backend/app/ ./app/
COPY --chown=appuser:appgroup cerberus_universal_backend/run.py .
COPY --chown=appuser:appgroup cerberus_universal_backend/migrations/ ./migrations/
COPY --chown=appuser:appgroup cerberus_universal_backend/alembic.ini .

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
