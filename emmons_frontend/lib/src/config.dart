// Configuration for the application

// Configuration for the application

// For local development with Flask backend running on port 5001:
// const String apiBaseUrl = 'http://127.0.0.1:5001/api/v1';
const String apiBaseUrl = 'https://campaigns-api-885603051818.us-south1.run.app/api/v1';

// Campaign ID for this specific frontend instance.
// This might be useful if the backend needs to know which campaign site is making the request.
// For example, if "Emmons-Frontend" corresponds to campaign_id 1 in your database:
const int currentCampaignId = 1;

// Other global configurations can be added here
// For example, feature flags, timeouts, etc.
const int defaultNetworkTimeoutSeconds = 30;

const String stripePublicKey = 'pk_live_51QoUvvLiE3PH27cBZ4Nt4532BV0fKKSe5gVG9TTP78yieeoowhCtDy8oWgZKXAOw1Jqm05sWeyee4dUIcyzi25lc00dP9pymbT';
