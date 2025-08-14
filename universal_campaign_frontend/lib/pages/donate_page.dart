import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/config/campaign_config.dart';

class DonatePage extends StatelessWidget {
  final CampaignConfig config;

  const DonatePage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.content.donatePage.appBarTitle),
      ),
      body: const Center(
        child: Text('Donate Page'),
      ),
    );
  }
}
