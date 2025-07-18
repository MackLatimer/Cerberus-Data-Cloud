# --- Stage 1: Builder ---
# This stage installs build dependencies and Python packages into a virtual environment.
FROM python:3.9-slim AS builder

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Install build-time dependencies for compiling Python packages with C extensions.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Set the working directory
WORKDIR /app

# Copy only the requirements file to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies into the virtual environment
RUN pip install --no-cache-dir -r requirements.txt

# --- Stage 2: Production ---
# This stage creates the final, lean image for production.
FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV FLASK_APP=run.py
ENV FLASK_ENV=production
ENV PORT=5001
ENV PATH="/opt/venv/bin:$PATH"

# Set the working directory in the container
WORKDIR /app

# Install only runtime dependencies (e.g., for psycopg2)
RUN apt-get update && apt-get install -y --no-install-recommends libpq5 && rm -rf /var/lib/apt/lists/*

# Create a non-root user to run the application for better security
RUN useradd --system --no-create-home --shell /bin/false appuser

# Copy the virtual environment from the builder stage
COPY --from=builder /opt/venv /opt/venv

COPY . /app/

# Switch to the non-root user
USER appuser

EXPOSE $PORT

CMD gunicorn --bind "0.0.0.0:$PORT" --workers 4 --access-logfile - --error-logfile - run:app