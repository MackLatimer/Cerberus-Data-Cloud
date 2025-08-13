import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/src/models/campaign_config.dart';

class CampaignConfigService {
  static final Map<String, CampaignConfig> _campaigns = {
    'emmons': CampaignConfig(
      campaignId: 'emmons',
      siteTitle: 'Curtis Emmons for County Commissioner',
      logoPath: 'assets/images/Emmons_Logo_4.png',
      stripePublicKey: 'pk_test_51Rnnfv4brLkKMnfT9dQISZb1hLmvQMVq3nr8Ymb67lqFQ4JwJkTrc92dRUXKYvYs3tSMeYZkTgIkKJxLsOmjqTN800f2UFiJiT',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF002663),
          primary: const Color(0xFF002663),
          secondary: const Color(0xFFA01124),
          surface: const Color(0xFFFFFFFF),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF000000),
          onError: Colors.white,
          error: Colors.red.shade700,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 152, color: Color(0xFF000000), fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 122, color: Color(0xFF000000), fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 98, color: Color(0xFF000000), fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 78, color: Color(0xFF000000), fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 62, color: Color(0xFF000000), fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 50, color: Color(0xFF000000), fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 40, color: Color(0xFF000000), fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 32, color: Color(0xFF000000), fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 25, color: Color(0xFF000000), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontFamily: 'Tinos', fontSize: 20, color: Color(0xFF000000)),
          bodyMedium: TextStyle(fontFamily: 'Tinos', fontSize: 16, color: Color(0xFF000000)),
          bodySmall: TextStyle(fontFamily: 'Tinos', fontSize: 12.8, color: Color(0xFF000000)),
          labelLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          labelMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 16, fontWeight: FontWeight.bold),
          labelSmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 12.8, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA01124),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontFamily: 'BebasNeue', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFA01124),
            textStyle: const TextStyle(fontFamily: 'BebasNeue', fontSize: 16, fontWeight: FontWeight.bold).copyWith(color: const Color(0xFFA01124)),
          ),
        ),
      ),
    ),
  };

  static CampaignConfig getConfig(String campaignId) {
    return _campaigns[campaignId] ?? _campaigns['emmons']!;
  }
}
