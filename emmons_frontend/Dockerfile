# Stage 1: Build the Flutter application
# Using the latest stable Flutter image
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Set working directory for Flutter build
WORKDIR /app_src

# Copy pubspec.yaml first to leverage Docker cache
COPY pubspec.yaml ./

# Remove the lock file to force a fresh dependency resolution
RUN rm -f pubspec.lock

# Get dependencies
RUN flutter pub get

# Copy the rest of the frontend application code, excluding assets/images via .dockerignore
COPY lib/ ./lib/
COPY assets/ ./assets/
COPY web/ ./web/

# Build the web application
# Using --release for a production build
RUN flutter build web --release

# List the contents of the build directory for diagnostics
RUN ls -lR /app_src/build/web

# Verify that main.dart.js exists
RUN test -f /app_src/build/web/main.dart.js || (echo "main.dart.js not found!" && exit 1)

# Stage 2: Serve the built web application with Nginx
FROM nginx:1.25-alpine

# Copy the built static files from the 'build' stage
# The output of 'flutter build web' is in 'build/web'
COPY --from=build /app_src/build/web /usr/share/nginx/html

# Copy a custom Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
