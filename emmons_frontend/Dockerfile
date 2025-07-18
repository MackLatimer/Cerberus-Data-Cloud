# Stage 1: Build the Flutter application
# Using ghcr.io/cirruslabs/flutter image
FROM ghcr.io/cirruslabs/flutter:3.22.1 AS build

# Set working directory for Flutter build
WORKDIR /app_src

# Copy pubspec.yaml and pubspec.lock first to leverage Docker cache
COPY pubspec.yaml ./
COPY pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the frontend application code
COPY . .

# Define build arguments that can be passed in from cloudbuild.yaml
ARG API_BASE_URL
ARG CAMPAIGN_ID
ARG STRIPE_PUBLISHABLE_KEY

# Build the web application
# Using --release for a production build
# Pass the build arguments as compile-time variables to the Flutter app
RUN flutter build web --release \
    --dart-define=API_BASE_URL=${API_BASE_URL} \
    --dart-define=CAMPAIGN_ID=${CAMPAIGN_ID} \
    --dart-define=STRIPE_PUBLISHABLE_KEY=${STRIPE_PUBLISHABLE_KEY}

# Stage 2: Serve the built web application with Nginx
FROM nginx:1.25-alpine

# Install gettext package which provides the 'envsubst' utility
RUN apk --no-cache add gettext

# Copy the built static files from the 'build' stage
# The output of 'flutter build web' is in 'build/web'
COPY --from=build /app_src/build/web /usr/share/nginx/html

# Copy the Nginx configuration template
COPY nginx.conf.template /etc/nginx/conf.d/default.conf.template

# Copy and make the startup script executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port 80
EXPOSE 80

# Command to run the startup script
CMD ["/start.sh"]