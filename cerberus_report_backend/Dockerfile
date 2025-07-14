FROM python:3.10
WORKDIR /app
RUN python --version > /app/python_version.txt && cat /app/python_version.txt
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
COPY cerberus_report_backend/api.py .
EXPOSE 8080
ENV PORT 8080
ENV PYTHONUNBUFFERED TRUE
# Run api.py when the container launches using Gunicorn
# Use shell form to ensure $PORT environment variable is expanded
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT api:app"]
