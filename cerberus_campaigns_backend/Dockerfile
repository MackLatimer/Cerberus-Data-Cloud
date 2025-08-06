# Stage 1: Builder
FROM python:3.9-slim as builder

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends build-essential libpq-dev

# Copy requirements and build wheels
COPY requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt


# Stage 2: Final image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV FLASK_APP=run.py
ENV FLASK_ENV=production
ENV PORT=5001

# Set the working directory in the container
WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends libpq5 && rm -rf /var/lib/apt/lists/*

# Copy wheels from builder stage
COPY --from=builder /wheels /wheels

# Install python dependencies from wheels
RUN pip install --no-cache /wheels/*

# Copy application code
COPY . /app/

# Expose port
EXPOSE $PORT

# Run the application
CMD gunicorn --bind "0.0.0.0:$PORT" --workers 2 --access-logfile - --error-logfile - run:app