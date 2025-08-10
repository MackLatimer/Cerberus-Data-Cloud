# ---- Stage 1: Build ----
# Use a specific version of the Flutter SDK for reproducible builds.
# Using cirrusci/flutter as it's a common choice for CI/CD.
FROM cirrusci/flutter:3.22.2 as build

WORKDIR /app

# Copy dependency definition files first to leverage Docker's layer caching.
COPY pubspec.yaml pubspec.lock ./

# Install Flutter dependencies.
RUN flutter pub get

# Copy the rest of the application source code.
COPY . .

# Build the Flutter web application for release.
# The output will be in the /app/build/web directory.
RUN flutter build web --release

# ---- Stage 2: Serve ----
# Use a lightweight and secure Nginx image to serve the static files.
FROM nginx:1.25-alpine as final

# Copy the custom Nginx configuration for the SPA.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built Flutter web application from the 'build' stage.
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80 to allow incoming traffic.
# Cloud Run will automatically map its external URL to this port.
EXPOSE 80

# Start the Nginx server in the foreground.
CMD ["nginx", "-g", "daemon off;"]
