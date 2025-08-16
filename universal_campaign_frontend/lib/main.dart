import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';
import 'package:universal_campaign_frontend/models/campaign_config.dart';
import 'package:universal_campaign_frontend/pages/about_page.dart';
import 'package:universal_campaign_frontend/pages/coming_soon_page.dart';
import 'package:universal_campaign_frontend/pages/donate_page.dart';
import 'package:universal_campaign_frontend/pages/endorsements_page.dart';
import 'package:universal_campaign_frontend/pages/error_page.dart';
import 'package:universal_campaign_frontend/pages/home_page.dart';
import 'package:universal_campaign_frontend/pages/issues_page.dart';
import 'package:universal_campaign_frontend/pages/privacy_policy_page.dart';
import 'package:universal_campaign_frontend/providers/campaign_provider.dart';

import 'package:universal_campaign_frontend/locator.dart';

void main() {
  setupLocator();
  setUrlStrategy(const HashUrlStrategy());
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final provider = locator<CampaignProvider>();
        final campaignId = Uri.base.queryParameters['campaign'];
        provider.loadCampaign(campaignId ?? 'default');
        return provider;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CampaignProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return ErrorPage(errorMessage: provider.error!, config: null);
        }

        if (provider.campaignConfig == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final config = provider.campaignConfig!;
        return buildApp(context, config);
      },
    );
  }

  Widget buildApp(BuildContext context, CampaignConfig config) {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutPage(),
        ),
        GoRoute(
          path: '/coming-soon',
          builder: (context, state) => const ComingSoonPage(),
        ),
        GoRoute(
          path: '/donate',
          builder: (context, state) => const DonatePage(),
        ),
        GoRoute(
          path: '/endorsements',
          builder: (context, state) => const EndorsementsPage(),
        ),
        GoRoute(
          path: '/issues',
          builder: (context, state) => const IssuesPage(),
        ),
        GoRoute(
          path: '/privacy-policy',
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
      ],
    );

    return MaterialApp.router(
      title: config.content.siteTitle,
      theme: _buildTheme(context, config),
      routerConfig: router,
    );
  }

  ThemeData _buildTheme(BuildContext context, CampaignConfig config) {
    Color primaryColor = _parseColor(config.theme.primaryColor, Colors.blue);
    Color secondaryColor = _parseColor(config.theme.secondaryColor, Colors.amber);
    Color backgroundColor = _parseColor(config.theme.backgroundColor, Colors.white);
    Color textColor = _parseColor(config.theme.textColor, Colors.black);

    final TextTheme appTextTheme = Theme.of(context).textTheme.copyWith(
          displayLarge: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 152, color: textColor, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 122, color: textColor, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 98, color: textColor, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 78, color: textColor, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 62, color: textColor, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 50, color: textColor, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 40, color: textColor, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 32, color: textColor, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 25, color: textColor, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontFamily: config.theme.secondaryFontFamily, fontSize: 20, color: textColor),
          bodyMedium: TextStyle(fontFamily: config.theme.secondaryFontFamily, fontSize: 16, color: textColor),
          bodySmall: TextStyle(fontFamily: config.theme.secondaryFontFamily, fontSize: 12.8, color: textColor),
          labelLarge: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          labelMedium: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 16, fontWeight: FontWeight.bold),
          labelSmall: TextStyle(fontFamily: config.theme.fontFamily, fontSize: 12.8, fontWeight: FontWeight.bold),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
        onError: Colors.white,
        error: Colors.red.shade700,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: appTextTheme.apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        titleTextStyle: appTextTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          textStyle: appTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryColor,
          textStyle: appTextTheme.labelMedium?.copyWith(color: secondaryColor),
        ),
      ),
    );
  }

  Color _parseColor(String colorString, Color defaultColor) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      } else {
        return Color(int.parse(colorString, radix: 16) + 0xFF000000);
      }
    } catch (e) {
      return defaultColor;
    }
  }
}
