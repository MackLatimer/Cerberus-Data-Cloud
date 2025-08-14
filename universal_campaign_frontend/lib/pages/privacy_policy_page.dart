import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/config/campaign_config.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final CampaignConfig config;

  const PrivacyPolicyPage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.content.privacyPolicyPage.appBarTitle),
      ),
      body: const Center(
        child: Text('Privacy Policy Page'),
      ),
    );
  }
}
