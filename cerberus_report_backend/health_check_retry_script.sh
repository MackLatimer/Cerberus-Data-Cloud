echo "Starting subtask to verify API and Database Health (Retry)."

# Environment variables (INSTANCE_CONNECTION_NAME, DB_USER, DB_PASS, DB_NAME)
# are assumed to be set in the GCP environment and accessible to api.py.

echo "Installing dependencies..."
# Determine Python version for site-packages path dynamically
# This makes the script more robust than hardcoding 3.9
PY_VERSION_MAJOR=$(python3 -c 'import sys; print(sys.version_info.major)')
PY_VERSION_MINOR=$(python3 -c 'import sys; print(sys.version_info.minor)')
USER_SITE_PACKAGES_DIR="$HOME/.local/lib/python$PY_VERSION_MAJOR.$PY_VERSION_MINOR/site-packages"

python3 -m pip install --user --no-cache-dir --force-reinstall flask flask-cors psycopg2-binary cloud-sql-python-connector requests

# Ensure Python's user install bin directory is in PATH
export PATH="$HOME/.local/bin:$PATH"
# Ensure Python can find user-installed packages
export PYTHONPATH="$USER_SITE_PACKAGES_DIR:$PYTHONPATH"

echo "User PATH: $PATH"
echo "User PYTHONPATH: $PYTHONPATH"
echo "Expected User site-packages: $USER_SITE_PACKAGES_DIR"

echo "Attempting to run api.py..."
python3 api.py > api_output.log 2>&1 &
API_PID=$!
sleep 8 # Increased sleep time to allow for Cloud SQL connector initialization

echo "Checking if API process started..."
if ! ps -p $API_PID > /dev/null; then
    echo "ERROR_ENCOUNTERED: API process failed to start."
    echo "Contents of api_output.log:"
    cat api_output.log
    # Try to run python with verbose output to find issues
    echo "Attempting to run api.py with verbose python to see module loading..."
    # Ensure api.py is not already running due to a previous failed attempt or backgrounding
    # This python3 -v command should not be backgrounded
    python3 -v api.py > api_verbose_output.log 2>&1
    echo "Contents of api_verbose_output.log:"
    cat api_verbose_output.log
    # exit 1 # Removed to allow script to finish and report
    echo "SCRIPT_TERMINATION_SIGNALLED: API failed to start, subsequent tests might fail."
else
    echo "API process started (PID: $API_PID). Checking output log."
    cat api_output.log

    echo "Checking for common error messages in API log..."
    if grep -q "Missing database connection environment variables" api_output.log; then
        echo "ERROR_ENCOUNTERED: api.py reported missing database environment variables. This indicates the GCP-set variables are not being picked up by this execution environment."
    fi
    if grep -q "Database connection failed" api_output.log; then
        echo "ERROR_ENCOUNTERED: api.py reported a database connection failure. This could be due to incorrect credentials, firewall issues, or the Cloud SQL instance not being ready."
    fi
    if grep -E "Error|Exception" api_output.log; then # More generic error check
         # Avoid flagging known/expected "connection failed" messages as generic "WARNING"
        if ! grep -q "Database connection failed" api_output.log && ! grep -q "Missing database connection environment variables" api_output.log ; then
            echo "WARNING: Potential errors or exceptions found in api_output.log (that are not DB connection related). Review carefully."
        fi
    fi

    echo "Testing /test_db endpoint..."
    # Ensure curl is installed (should be handled by environment, but good practice)
    if ! command -v curl &> /dev/null; then
        echo "curl could not be found, attempting to install it."
        sudo apt-get update && sudo apt-get install -y curl
    fi
    curl -s -f http://localhost:8080/test_db > test_db_output.json
    CURL_EXIT_CODE=$?

    if [ $CURL_EXIT_CODE -eq 0 ]; then
        echo "/test_db response:"
        cat test_db_output.json
        if grep -q "Database connection successful" test_db_output.json; then
            echo "SUCCESS: /test_db endpoint indicates database connection is okay."
        else
            echo "ERROR_ENCOUNTERED: /test_db endpoint did not report a successful connection. Response was:"
            cat test_db_output.json
            echo "Debug DB URL info:"
            curl -s http://localhost:8080/debug_db_url
        fi
    else
        echo "ERROR_ENCOUNTERED: Failed to connect to /test_db endpoint. Curl exit code: $CURL_EXIT_CODE"
        echo "Debug DB URL info:"
        curl -s http://localhost:8080/debug_db_url
    fi

    echo "Testing /municipalities endpoint..."
    curl -s -f http://localhost:8080/municipalities > municipalities_output.json
    CURL_EXIT_CODE_MUNI=$?

    if [ $CURL_EXIT_CODE_MUNI -eq 0 ]; then
        echo "/municipalities response:"
        cat municipalities_output.json
        echo "SUCCESS: /municipalities endpoint accessible."
        if grep -q '^\[.*\]$' municipalities_output.json; then
            echo "SUCCESS: /municipalities returned a JSON array."
        elif grep -q '\[\]' municipalities_output.json; then
             echo "INFO: /municipalities returned an empty JSON array."
        else
            echo "WARNING: /municipalities did not return a JSON array as expected. It might be an error structure or unexpected format."
            cat municipalities_output.json
        fi
    else
        echo "ERROR_ENCOUNTERED: Failed to connect to /municipalities endpoint. Curl exit code: $CURL_EXIT_CODE_MUNI"
    fi

    echo "Testing base / endpoint..."
    curl -s -f http://localhost:8080/ > health_check_base_output.json
    CURL_EXIT_CODE_BASE=$?
    if [ $CURL_EXIT_CODE_BASE -eq 0 ]; then
        echo "/ response:"
        cat health_check_base_output.json
        if grep -q "API is running and healthy" health_check_base_output.json; then
            echo "SUCCESS: Base / endpoint indicates API is running."
        else
            echo "WARNING: Base / endpoint accessible but did not contain expected health message."
        fi
    else
        echo "ERROR_ENCOUNTERED: Failed to connect to base / endpoint. Curl exit code: $CURL_EXIT_CODE_BASE"
    fi
fi

echo "API and Database health check subtask (Retry) performing cleanup."
if ps -p $API_PID > /dev/null; then
    kill $API_PID
    wait $API_PID 2>/dev/null # Wait for process to terminate and suppress "Terminated" message
    echo "API process terminated."
else
    echo "API process was not running or already terminated."
fi
echo "Health check script (Retry) finished."
