// This file centralizes access to environment variables and other global configurations.

// API Base URL - Loaded from compile-time variables.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:5001/api/v1', // Fallback for local dev
);

// Campaign ID for this specific frontend instance.
// Loaded from compile-time variables.
const String currentCampaignId = String.fromEnvironment(
  'CAMPAIGN_ID',
  defaultValue: '1', // Fallback for local dev
);

// Stripe Publishable Key - Loaded from compile-time variables.
const String stripePublishableKey = String.fromEnvironment(
  'STRIPE_PUBLISHABLE_KEY',
  defaultValue: 'pk_test_YOUR_FALLBACK_TEST_KEY_HERE', // Fallback for local dev
);

// Other global configurations can be added here.
const int defaultNetworkTimeoutSeconds = 30;