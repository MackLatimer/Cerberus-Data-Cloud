import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/config/campaign_config.dart';

class EndorsementsPage extends StatelessWidget {
  final CampaignConfig config;

  const EndorsementsPage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.content.endorsementsPage.appBarTitle),
      ),
      body: const Center(
        child: Text('Endorsements Page'),
      ),
    );
  }
}
