import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:universal_campaign_frontend/models/campaign_config.dart';

class ConfigService {
  static Future<CampaignConfig> loadCampaignConfig(String campaignId) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/${campaignId}_config.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return CampaignConfig.fromJson(jsonMap);
    } catch (e) {
      if (kDebugMode) {
        // Replaced print with debugPrint
        debugPrint('Error loading campaign config for $campaignId: $e');
      }
      // If loading the specific campaign fails, load the error config.
      final String jsonString = await rootBundle.loadString('assets/error_config.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return CampaignConfig.fromJson(jsonMap);
    }
  }

  static Future<String> getDefaultCampaignId() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/default_config.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return jsonMap['default_campaign_id'];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading default campaign id: $e');
      }
      // If default config is missing or invalid, return a hardcoded default.
      return 'emmons';
    }
  }
}
