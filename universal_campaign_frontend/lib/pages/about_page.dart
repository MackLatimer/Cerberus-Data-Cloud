import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/config/campaign_config.dart';

class AboutPage extends StatelessWidget {
  final CampaignConfig config;

  const AboutPage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.content.aboutPage.appBarTitle),
      ),
      body: const Center(
        child: Text('About Page'),
      ),
    );
  }
}
