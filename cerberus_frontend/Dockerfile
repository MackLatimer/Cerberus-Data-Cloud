# Stage 1: Build Stage
# Use a pre-built, versioned Flutter image. This is much faster than installing
# Flutter from scratch and ensures reproducible builds.
FROM ghcr.io/cirruslabs/flutter:3.22.1 AS build

# Set the application's working directory
WORKDIR /app

# Copy dependency definition files first to leverage Docker's layer caching.
# This layer will only be rebuilt if pubspec.yaml or pubspec.lock changes.
COPY pubspec.* ./

# Install Flutter dependencies
RUN flutter pub get

# Copy the rest of the application source code into the container
COPY . .

# Build the Flutter web application for production
RUN flutter build web --release

# ---

# Stage 2: Production Stage
# Use a small, secure Nginx image for serving the static files.
FROM nginx:1.25-alpine

# Copy the built web application from the previous stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground so the container keeps running
CMD ["nginx", "-g", "daemon off;"]