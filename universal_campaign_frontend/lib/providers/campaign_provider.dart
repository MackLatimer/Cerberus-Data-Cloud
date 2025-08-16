import 'package:flutter/foundation.dart';
import 'package:universal_campaign_frontend/models/campaign_config.dart';
import 'package:universal_campaign_frontend/services/config_service.dart';

class CampaignProvider with ChangeNotifier {
  CampaignConfig? _campaignConfig;
  bool _isLoading = false;
  String? _error;

  CampaignConfig? get campaignConfig => _campaignConfig;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCampaign(String campaignId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _campaignConfig = await ConfigService.loadCampaignConfig(campaignId);
    } catch (e) {
      _error = 'An error occurred while loading the campaign.';
      if (kDebugMode) {
        print('Error in loadCampaign: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
