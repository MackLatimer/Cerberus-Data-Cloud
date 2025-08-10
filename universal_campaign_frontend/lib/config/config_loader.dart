import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' if (dart.library.io) 'package:universal_campaign_frontend/config/mock_html.dart';

import 'campaign_config.dart';
import 'campaigns.dart';

CampaignConfig? getCampaignConfig() {
  String hostname;
  if (kIsWeb) {
    hostname = window.location.hostname!;
  } else {
    // For non-web, which includes local development, we'll use a placeholder.
    // This logic assumes non-web execution is for development/testing.
    hostname = 'localhost';
  }

  if (hostname == 'localhost' || hostname == '127.0.0.1') {
    // Per instructions, default to 'emmons' for local development.
    return campaigns['emmons'];
  }

  // Find the campaign that matches the domain.
  for (final campaign in campaigns.values) {
    if (campaign.domain == hostname) {
      return campaign;
    }
  }

  // If no match is found, return null.
  return null;
}
