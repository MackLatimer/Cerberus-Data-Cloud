// Configuration for the application

// Configuration for the application

// For local development with Flask backend running on port 5001:
// const String apiBaseUrl = 'http://127.0.0.1:5001/api/v1';
// Example for a deployed backend:
const String apiBaseUrl = 'https://campaigns-api-885603051818.us-south1.run.app/api/v1';

// Campaign ID for this specific frontend instance.
// This might be useful if the backend needs to know which campaign site is making the request.
// TODO: Set this to the appropriate campaign ID from your backend's 'campaigns' table
// For example, if "Emmons-Frontend" corresponds to campaign_id 1 in your database:
const int currentCampaignId = 1;

// Other global configurations can be added here
// For example, feature flags, timeouts, etc.
const int defaultNetworkTimeoutSeconds = 30;

const String stripePublicKey = 'pk_test_51QoUvvLiE3PH27cBRO2pBOUFm2g3E51i656V4841i3iL4I2zUnEaRPO2u2zJkLpHUqYV3z3z3z3z3z3z3z3z3z3';
