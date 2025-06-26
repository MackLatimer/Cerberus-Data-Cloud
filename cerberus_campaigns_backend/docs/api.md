# Cerberus Backend API Documentation

## Base URL

The base URL for the API depends on the environment:
-   **Local Development:** `http://127.0.0.1:5001/api/v1` (assuming default Flask port 5001)
-   **Production:** (To be determined once deployed)

## Authentication

Currently, the `/api/v1/signups` endpoint is public and does not require authentication. Other API endpoints (e.g., for the voter data portal) will require authentication (details TBD).

## Endpoints

### Signup Endpoint

#### `POST /api/v1/signups`

Handles new signups from campaign websites (e.g., a website's "Join Us" or "Endorse" form). This endpoint will create a new `Voter` record if one doesn't exist (matched by email or phone), log an `Interaction`, and associate the voter with the specified `Campaign`.

**Request Body (JSON)**

```json
{
    "first_name": "string (required)",
    "last_name": "string (required)",
    "email_address": "string (email format, required)",
    "phone_number": "string (optional)",
    "campaign_id": "integer (required, ID of the campaign)",
    "middle_name": "string (optional)",
    "notes": "string (optional, general notes from signup form)",
    "interaction_type": "string (optional, defaults to 'Website Signup', e.g., 'Volunteer Signup', 'Endorsement')",
    "interests": {
        "wants_to_endorse": "boolean (optional)",
        "wants_to_get_involved": "boolean (optional)"
        // Other specific interests can be added here
    }
    // Potentially other voter fields like address, custom_fields, etc.
}
```

**Fields:**
-   `first_name`: (String, Required) First name of the person signing up.
-   `last_name`: (String, Required) Last name of the person signing up.
-   `email_address`: (String, Required) Email address of the person. Used for de-duplication.
-   `campaign_id`: (Integer, Required) The ID of the campaign this signup is for.
-   `phone_number`: (String, Optional) Phone number. Used for de-duplication if email doesn't match an existing record.
-   `middle_name`: (String, Optional) Middle name.
-   `notes`: (String, Optional) General notes captured from the signup form.
-   `interaction_type`: (String, Optional) Describes the type of signup. Defaults to "Website Signup" if not provided by the client. This helps categorize the interaction.
-   `interests`: (Object, Optional) A JSON object detailing specific interests expressed.
    -   `wants_to_endorse`: (Boolean, Optional) Indicates if the person wants to endorse.
    -   `wants_to_get_involved`: (Boolean, Optional) Indicates if the person wants to get involved/volunteer.

**Success Response (201 CREATED)**

```json
{
    "message": "Signup processed successfully.",
    "voter_id": "integer (ID of the created/updated voter)",
    "interaction_id": "integer (ID of the created interaction)"
}
```

**Error Responses:**

-   **400 Bad Request - Invalid or empty JSON payload**
    ```json
    {
        "error": "Invalid or empty JSON payload"
    }
    ```
    *Reason: Request body is missing, not valid JSON, or empty.*

-   **400 Bad Request - Missing required fields**
    ```json
    {
        "error": "Missing required fields: field1, field2, ..."
    }
    ```
    *Reason: One or more required fields (`first_name`, `last_name`, `email_address`, `campaign_id`) are missing from the payload.*

-   **404 Not Found - Campaign not found**
    ```json
    {
        "error": "Campaign with ID <campaign_id> not found."
    }
    ```
    *Reason: The provided `campaign_id` does not correspond to an existing campaign.*

-   **500 Internal Server Error**
    ```json
    {
        "error": "An internal error occurred. Please try again later."
    }
    ```
    *Reason: An unexpected error occurred on the server while processing the request.*


---
*Further endpoints (e.g., for CRUD operations on Voters, Campaigns, Users for the admin portal) will be documented here as they are developed and secured.*
