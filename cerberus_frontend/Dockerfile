# Use a specific version of the Ubuntu
FROM ubuntu:22.04

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter precache

# Set the working directory
WORKDIR /app

# Copy the pubspec.yaml and pubspec.lock files
COPY pubspec.* ./

# Get the dependencies
RUN flutter pub get

# Copy the rest of the application code
COPY . .

# Build the web application
RUN flutter build web

# Use a production-ready web server
FROM nginx:1.25-alpine

# Copy the built web application from the previous stage
COPY --from=0 /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the web server
CMD ["nginx", "-g", "daemon off;"]