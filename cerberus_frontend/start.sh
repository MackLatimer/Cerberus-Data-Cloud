#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Substitute the PORT environment variable into the Nginx config template
# and output it to the final config file location.
envsubst '${PORT}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start Nginx in the foreground
nginx -g 'daemon off;'