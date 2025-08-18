import 'package:universal_campaign_frontend/models/config/theme_config.dart';
import 'package:universal_campaign_frontend/models/config/content_config.dart';
import 'package:universal_campaign_frontend/models/config/assets_config.dart';

class CampaignConfig {
  final int campaignId;
  final bool defaultCampaign;
  final String stripeSecretKeySecretManagerName;
  final String stripeWebhookKeySecretManagerName;
  final String apiBaseUrl;
  final ThemeConfig theme;
  final ContentConfig content;
  final AssetsConfig assets;
  final String stripePublicKey;

  CampaignConfig({
    required this.campaignId,
    required this.defaultCampaign,
    required this.stripeSecretKeySecretManagerName,
    required this.stripeWebhookKeySecretManagerName,
    required this.apiBaseUrl,
    required this.theme,
    required this.content,
    required this.assets,
    required this.stripePublicKey,
  });

  factory CampaignConfig.fromJson(Map<String, dynamic> json) {
    return CampaignConfig(
      campaignId: json['campaignId'] as int? ?? 0,
      defaultCampaign: json['defaultCampaign'] ?? false,
      stripeSecretKeySecretManagerName: json['stripeSecretKeySecretManagerName'] ?? '',
      stripeWebhookKeySecretManagerName: json['stripeWebhookKeySecretManagerName'] ?? '',
      apiBaseUrl: json['apiBaseUrl'] ?? '',
      theme: ThemeConfig.fromJson(json['theme'] ?? {}),
      content: ContentConfig.fromJson(json['content'] ?? {}),
      assets: AssetsConfig.fromJson(json['assets'] ?? {}),
      stripePublicKey: json['stripePublicKey'] ?? '',
    );
  }
}