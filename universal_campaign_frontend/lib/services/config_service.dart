import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:universal_campaign_frontend/config/campaign_config.dart';

class ConfigService {
  static Future<CampaignConfig> loadCampaignConfig(String campaignId) async {
    final String jsonString = await rootBundle.loadString('assets/${campaignId}_config.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return CampaignConfig.fromJson(jsonMap);
  }

  static String getDefaultCampaignId() {
    // In the future, this could be fetched from a remote config
    // or determined by some other logic.
    return 'emmons';
  }
}
