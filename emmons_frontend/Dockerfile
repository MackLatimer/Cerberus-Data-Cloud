# Stage 1: Build the Flutter application
# Using cirrusci/flutter image
FROM cirrusci/flutter:3.19.0 AS build

# Set working directory for Flutter build
WORKDIR /app_src

# Copy pubspec.yaml and pubspec.lock first to leverage Docker cache
COPY pubspec.yaml ./
COPY pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the frontend application code
COPY . .

# Build the web application
# Using --release for a production build
RUN flutter build web --release

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