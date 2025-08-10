import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/config/campaign_config.dart';
import 'package:universal_campaign_frontend/config/config_loader.dart';
import 'package:universal_campaign_frontend/pages/error_page.dart';
import 'package:universal_campaign_frontend/pages/home_page.dart';

void main() {
  final CampaignConfig? config = getCampaignConfig();
  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final CampaignConfig? config;

  const MyApp({super.key, this.config});

  @override
  Widget build(BuildContext context) {
    // If config is null, the app is not configured for the current domain.
    // Show a MaterialApp with the ErrorPage as the home.
    if (config == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ErrorPage(
          message: 'This domain is not configured for any campaign.',
        ),
      );
    }

    // If a config is found, build the full-featured MaterialApp.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: config!.siteTitle,
      theme: ThemeData(
        fontFamily: config!.theme.fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: config!.theme.primaryColor,
          primary: config!.theme.primaryColor,
          secondary: config!.theme.secondaryColor,
          brightness: Brightness.light, // Or determine from config
        ),
        useMaterial3: true,
      ),
      // The home property is now the new HomePage, which is config-driven.
      home: HomePage(config: config!),
    );
  }
}
