import 'package:emmons_frontend/config/theme_config.dart';
import 'package:emmons_frontend/models/endorsement.dart';
import 'package:emmons_frontend/models/issue.dart';

class CampaignConfig {
  final String campaignId;
  final String domain;
  final String siteTitle;
  final ThemeConfig theme;
  final StripeConfig stripe;
  final ContentConfig content;
  final List<Issue> issues;
  final List<Endorsement> endorsements;

  CampaignConfig({
    required this.campaignId,
    required this.domain,
    required this.siteTitle,
    required this.theme,
    required this.stripe,
    required this.content,
    required this.issues,
    required this.endorsements,
  });

  factory CampaignConfig.fromJson(Map<String, dynamic> json) {
    var issuesList = json['issues'] as List;
    List<Issue> issues = issuesList.map((i) => Issue.fromJson(i)).toList();

    var endorsementsList = json['endorsements'] as List;
    List<Endorsement> endorsements =
        endorsementsList.map((i) => Endorsement.fromJson(i)).toList();

    return CampaignConfig(
      campaignId: json['campaignId'] as String,
      domain: json['domain'] as String,
      siteTitle: json['siteTitle'] as String,
      theme: ThemeConfig.fromJson(json['theme']),
      stripe: StripeConfig.fromJson(json['stripe']),
      content: ContentConfig.fromJson(json['content']),
      issues: issues,
      endorsements: endorsements,
    );
  }
}

class StripeConfig {
  final String publicKey;
  final String connectedAccountId;

  StripeConfig({required this.publicKey, required this.connectedAccountId});

  factory StripeConfig.fromJson(Map<String, dynamic> json) {
    return StripeConfig(
      publicKey: json['publicKey'] as String,
      connectedAccountId: json['connectedAccountId'] as String,
    );
  }
}

class ContentConfig {
  final String heroTitle;
  final String heroSubtitle;
  final String callToActionLabel;

  ContentConfig({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.callToActionLabel,
  });

  factory ContentConfig.fromJson(Map<String, dynamic> json) {
    return ContentConfig(
      heroTitle: json['heroTitle'] as String,
      heroSubtitle: json['heroSubtitle'] as String,
      callToActionLabel: json['callToActionLabel'] as String,
    );
  }
}
