import os
import requests
import json

# Get the API_URL from an environment variable
API_URL = os.environ.get("API_URL")

if not API_URL:
    print("Error: API_URL environment variable not set.")
    print("Please set it to the base URL of your deployed API, e.g., https://your-api-service-url.a.run.app")
    exit(1)

def test_endpoint(endpoint, description):
    """Tests a given API endpoint."""
    url = f"{API_URL}{endpoint}"
    print(f"Testing {description} at {url}...")
    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()  # Raises an exception for 4XX/5XX errors

        if response.status_code == 200:
            try:
                # Try to parse JSON, but not all 200 responses might be JSON (e.g. health check)
                if response.content:
                    json_data = response.json()
                    print(f"SUCCESS: {description} - Status {response.status_code}, Response: {json.dumps(json_data, indent=2)[:200]}...") # Print first 200 chars of JSON
                else:
                    print(f"SUCCESS: {description} - Status {response.status_code}, No content in response.")
            except json.JSONDecodeError:
                print(f"SUCCESS (but not JSON): {description} - Status {response.status_code}, Response: {response.text[:200]}...")
            return True
        else:
            print(f"FAILURE: {description} - Expected status 200, got {response.status_code}. Response: {response.text[:200]}...")
            return False

    except requests.exceptions.HTTPError as http_err:
        print(f"FAILURE: {description} - HTTP error occurred: {http_err}. Response: {response.text[:200]}...")
        return False
    except requests.exceptions.ConnectionError as conn_err:
        print(f"FAILURE: {description} - Connection error occurred: {conn_err}")
        return False
    except requests.exceptions.Timeout as timeout_err:
        print(f"FAILURE: {description} - Timeout error occurred: {timeout_err}")
        return False
    except requests.exceptions.RequestException as req_err:
        print(f"FAILURE: {description} - An error occurred: {req_err}")
        return False

def main():
    print(f"Starting API tests for base URL: {API_URL}\n")

    tests = [
        ("/test", "Health Check"),
        ("/test_db", "Database Connection Test"),
        ("/municipalities", "Municipalities Endpoint")
    ]

    all_passed = True
    for endpoint, description in tests:
        if not test_endpoint(endpoint, description):
            all_passed = False
        print("-" * 30)

    if all_passed:
        print("\nAll tests passed successfully!")
    else:
        print("\nSome tests failed.")
        exit(1)

if __name__ == "__main__":
    main()
