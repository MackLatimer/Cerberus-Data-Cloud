import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/config/campaign_config.dart';

class HomePage extends StatelessWidget {
  final CampaignConfig config;

  const HomePage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          config.assets.homePage.logoPath,
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Error: Logo image could not be loaded.',
              style: TextStyle(color: Colors.red, fontSize: 14),
            );
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                config.content.homePage.heroTitle,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(int.parse(config.theme.primaryColor.substring(1, 7), radix: 16) + 0xFF000000),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // TODO: Replace this with actual navigation logic, e.g.,
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => DonatePage()));
                  print('Call to Action button pressed!');
                },
                child: Text(config.content.homePage.callToActionText),
              ),
              const SizedBox(height: 60),
              // We can add sections for Issues and Endorsements here later
            ],
          ),
        ),
      ),
    );
  }
}

