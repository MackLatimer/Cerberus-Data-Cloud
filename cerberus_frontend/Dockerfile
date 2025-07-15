# Use a specific version of the Flutter SDK
FROM google/flutter:latest

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