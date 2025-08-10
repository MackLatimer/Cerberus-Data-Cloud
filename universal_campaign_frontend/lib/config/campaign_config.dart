import 'package:flutter/material.dart';

class CampaignConfig {
  final String campaignId;
  final String domain;
  final String siteTitle;
  final String apiBaseUrl;
  final ThemeConfig theme;
  final StripeConfig stripe;
  final ContentConfig content;
  final List<Issue> issues;
  final List<Endorsement> endorsements;

  const CampaignConfig({
    required this.campaignId,
    required this.domain,
    required this.siteTitle,
    required this.apiBaseUrl,
    required this.theme,
    required this.stripe,
    required this.content,
    required this.issues,
    required this.endorsements,
  });
}

class ThemeConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final String fontFamily;
  final String logoUrl;

  const ThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.fontFamily,
    required this.logoUrl,
  });
}

class StripeConfig {
  final String publicKey;
  final String connectedAccountId;

  const StripeConfig({
    required this.publicKey,
    required this.connectedAccountId,
  });
}

class ContentConfig {
  final String heroTitle;
  final String heroSubtitle;
  final String callToActionLabel;

  const ContentConfig({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.callToActionLabel,
  });
}

class Issue {
  final String title;
  final String description;
  final String imageUrl;

  const Issue({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class Endorsement {
  final String endorserName;
  final String quote;
  final String logoUrl;

  const Endorsement({
    required this.endorserName,
    required this.quote,
    required this.logoUrl,
  });
}
