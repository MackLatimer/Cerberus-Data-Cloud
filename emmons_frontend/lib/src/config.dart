import 'package:flutter_dotenv/flutter_dotenv.dart';

// This file centralizes access to environment variables and other global configurations.

// API Base URL - Loaded from the .env file.
// Provides a fallback to a local URL for easy development.
final String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:5001/api/v1';

// Campaign ID for this specific frontend instance.
// Loaded from the .env file.
final String currentCampaignId = dotenv.env['CAMPAIGN_ID'] ?? '1';

// Other global configurations can be added here.
const int defaultNetworkTimeoutSeconds = 30;