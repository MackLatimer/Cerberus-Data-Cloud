import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/config/campaign_config.dart';

class IssuesPage extends StatelessWidget {
  final CampaignConfig config;

  const IssuesPage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.content.issuesPage.appBarTitle),
      ),
      body: const Center(
        child: Text('Issues Page'),
      ),
    );
  }
}
