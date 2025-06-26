# Stage 1: Diagnostic - Can we pull a basic image from Docker Hub?
FROM alpine:latest AS build

# If the above line works, Cloud Build can reach Docker Hub.
# We'll just do a simple command to make the build proceed if it works.
RUN echo "Alpine image pulled successfully."

# Stage 2: Serve a placeholder (real build is bypassed for this test)
FROM nginx:1.25-alpine
COPY emmons_frontend/nginx.conf /etc/nginx/conf.d/default.conf
RUN echo "Hello from Nginx placeholder" > /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]