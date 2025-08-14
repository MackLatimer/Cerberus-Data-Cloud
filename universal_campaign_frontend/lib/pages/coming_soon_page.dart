import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/config/campaign_config.dart';

class ComingSoonPage extends StatelessWidget {
  final CampaignConfig config;

  const ComingSoonPage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.content.comingSoonPage.title),
      ),
      body: Center(
        child: Text(config.content.comingSoonPage.message),
      ),
    );
  }
}
