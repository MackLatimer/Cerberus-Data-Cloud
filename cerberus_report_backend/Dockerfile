# --- Stage 1: Builder ---
# This stage installs build dependencies and Python packages into a virtual environment.
FROM python:3.10-slim AS builder

# Set environment variables for a cleaner build
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Install build-time dependencies for compiling Python packages with C extensions.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment for dependency isolation
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Set the working directory
WORKDIR /app

# Copy only the requirements file to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies into the virtual environment
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# --- Stage 2: Production ---
# This stage creates the final, lean image for production.
FROM python:3.10-slim

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV PORT=8080
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

# Create a non-root user to run the application for better security
RUN useradd --system --no-create-home --shell /bin/false appuser

# Copy the virtual environment from the builder stage
COPY --from=builder /opt/venv /opt/venv

# Copy application code and switch to the non-root user
COPY api.py scraper.py notification_sender.py ./
USER appuser

EXPOSE 8080

CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT api:app"]
