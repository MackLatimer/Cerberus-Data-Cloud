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
        title: Image.network(
          config.theme.logoUrl,
          height: 40,
          fit: BoxFit.contain,
          // Provide a specific error message as requested
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Error: Logo image could not be loaded.',
              style: TextStyle(color: Colors.red, fontSize: 14),
            );
          },
          // A loading builder can improve user experience
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
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
                config.content.heroTitle,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: config.theme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                config.content.heroSubtitle,
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement navigation or action for the CTA
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                  textStyle: textTheme.titleMedium,
                ),
                child: Text(config.content.callToActionLabel),
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
