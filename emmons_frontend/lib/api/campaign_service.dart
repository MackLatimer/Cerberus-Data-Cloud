import 'dart:convert';
import 'package:emmons_frontend/config/campaign_config.dart';
import 'package:flutter/services.dart';

class CampaignService {
  /// Fetches the configuration for a given campaign identifier.
  ///
  /// In a real application, the [campaignIdentifier] might be derived from the
  /// browser's hostname (`window.location.hostname`).
  ///
  /// This implementation simulates a network request by loading a local JSON
  /// asset file that corresponds to the campaign identifier.
  Future<CampaignConfig> fetchConfigFor(String campaignIdentifier) async {
    // Construct the path to the local asset.
    final path = 'assets/campaign_configs/$campaignIdentifier.json';

    try {
      // Load the JSON string from the asset bundle.
      final jsonString = await rootBundle.loadString(path);

      // Decode the JSON string into a Map.
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;

      // Use the fromJson factory to create a CampaignConfig instance.
      return CampaignConfig.fromJson(jsonMap);
    } catch (e) {
      // If the file fails to load or parse, rethrow a more informative error.
      print('Failed to load campaign config for "$campaignIdentifier": $e');
      rethrow;
    }
  }
}
