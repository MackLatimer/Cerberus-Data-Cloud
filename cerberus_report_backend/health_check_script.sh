echo "Starting subtask to verify API and Database Health."

echo "--- Python and Pip Diagnostics ---"
echo "which python3:"
which python3
echo "python3 --version:"
python3 --version
echo "which pip3:"
which pip3
echo "pip3 --version:"
pip3 --version

# Ensure user's local bin is in PATH (for any executables installed by pip)
export PATH="$HOME/.local/bin:$PATH"

# Ensure user's site-packages is in PYTHONPATH
PY_VERSION_SHORT=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
USER_SITE_PACKAGES="$HOME/.local/lib/python$PY_VERSION_SHORT/site-packages"
export PYTHONPATH="$USER_SITE_PACKAGES:$PYTHONPATH"

echo "User PATH: $PATH"
echo "User PYTHONPATH: $PYTHONPATH"
echo "Expected User site-packages: $USER_SITE_PACKAGES"
echo "--- End Diagnostics ---"

echo "Installing Python dependencies using python3 -m pip..."
python3 -m pip install --user --upgrade pip
python3 -m pip install --user --no-cache-dir --force-reinstall flask flask-cors psycopg[binary] cloud-sql-python-connector

echo "--- Post-install Diagnostics ---"
echo "pip3 freeze:"
python3 -m pip freeze
echo "sys.path from python3:"
python3 -c "import sys; print(sys.path)"
echo "--- End Post-install Diagnostics ---"

echo "Attempting to run api.py using python3..."
# Set environment variables for the API -
# These are placeholders. Actual values would be needed for a real DB connection.
# For this health check, the API should start, but /test_db will likely fail if these are not set
# to connect to a real DB. The check below looks for "Missing database connection" if these are not set.
export INSTANCE_CONNECTION_NAME="your-project:your-region:your-instance"
export DB_USER="your-db-user"
export DB_PASS="your-db-pass"
export DB_NAME="your-db-name"

python3 api.py > api_output.log 2>&1 &
API_PID=$!
sleep 8

echo "Checking if API process started..."
if ! ps -p $API_PID > /dev/null; then
    echo "ERROR_ENCOUNTERED: API process failed to start."
    echo "Contents of api_output.log:"
    cat api_output.log
else
    echo "API process started (PID: $API_PID). Checking output log."
    cat api_output.log

    echo "Checking for common error messages in API log..."
    # Check for missing env vars first, as this is a common setup issue for this app
    if grep -q "Missing database connection environment variables" api_output.log; then
        echo "ERROR_ENCOUNTERED: api.py reported missing database environment variables. These were set to placeholder values."
        echo "This is EXPECTED if actual database credentials are not provided for the test."
    elif grep -q "Database connection failed" api_output.log; then
        echo "ERROR_ENCOUNTERED: api.py reported a database connection failure."
        echo "This is EXPECTED if actual database credentials are not provided or are incorrect."
    elif grep -E "(Error|Exception)" api_output.log; then
        if grep -q "Connection refused" api_output.log || grep -q "Public IP address is not available" api_output.log || grep -q "Failed to establish a connection" api_output.log || grep -q "invalid instance connection name" api_output.log ; then
            echo "WARNING: API started but likely failed to connect to DB. This is EXPECTED if DB environment variables are placeholders or incorrect."
        else
            echo "WARNING: Potential errors or exceptions found in api_output.log. Review carefully."
        fi
    fi

    echo "Testing /test_db endpoint..."
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
            echo "ERROR_ENCOUNTERED: /test_db endpoint did not report a successful connection (or API is up but DB connection failed as expected with placeholders). Response was:"
            cat test_db_output.json
            echo "Debug DB URL info (from API):"
            curl -s http://localhost:8080/debug_db_url
        fi
    else
        echo "ERROR_ENCOUNTERED: Failed to connect to /test_db endpoint. Curl exit code: $CURL_EXIT_CODE"
        echo "This might be because the API itself is not fully functional due to expected DB connection issues."
        echo "Debug DB URL info (from API, if reachable):"
        curl -s http://localhost:8080/debug_db_url
    fi

    echo "Testing /municipalities endpoint..."
    curl -s -f http://localhost:8080/municipalities > municipalities_output.json
    CURL_EXIT_CODE_MUNI=$?

    if [ $CURL_EXIT_CODE_MUNI -eq 0 ]; then
        echo "/municipalities response:"
        cat municipalities_output.json
        echo "SUCCESS: /municipalities endpoint accessible."
    else
        echo "ERROR_ENCOUNTERED: Failed to connect to /municipalities endpoint. Curl exit code: $CURL_EXIT_CODE_MUNI"
        echo "This might be because the API itself is not fully functional due to expected DB connection issues."
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

echo "API and Database health check subtask performing cleanup."
if ps -p $API_PID > /dev/null; then
    kill $API_PID
    wait $API_PID 2>/dev/null
    echo "API process terminated."
else
    echo "API process was not running or already terminated."
fi
echo "Health check script finished."
