// Configuration for the application

// Configuration for the application

// For local development with Flask backend running on port 5001:
// const String apiBaseUrl = 'http://127.0.0.1:5001/api/v1';
// Example for a deployed backend:
const String apiBaseUrl = 'https://campaigns-api-885603051818.us-south1.run.app/api/v1';

// Campaign ID for this specific frontend instance.
const int currentCampaignId = 1;

// Other global configurations can be added here
// For example, feature flags, timeouts, etc.
const int defaultNetworkTimeoutSeconds = 30;
