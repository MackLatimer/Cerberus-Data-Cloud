import 'package:flutter/material.dart';

class CampaignConfig {
  final String campaignId;
  final ThemeData theme;
  final String siteTitle;
  final String stripePublicKey;
  final String logoPath;

  CampaignConfig({
    required this.campaignId,
    required this.theme,
    required this.siteTitle,
    required this.stripePublicKey,
    required this.logoPath,
  });
}
