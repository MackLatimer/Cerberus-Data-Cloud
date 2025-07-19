# Stage 1: Build the Flutter application
# Using ghcr.io/cirruslabs/flutter image
FROM ghcr.io/cirruslabs/flutter:3.22.1 AS build

# Set working directory for Flutter build
WORKDIR /app

# Copy pubspec.yaml and pubspec.lock first to leverage Docker cache
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the frontend application code
COPY . .

# Build the web application
# Using --release for a production build
RUN flutter build web

# Stage 2: Serve the built web application with Nginx
FROM nginx:1.25-alpine

# Copy the built static files from the 'build' stage
# The output of 'flutter build web' is in 'build/web'
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]