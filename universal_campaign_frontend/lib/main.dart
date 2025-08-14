import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:universal_campaign_frontend/models/campaign_config.dart';
import 'package:universal_campaign_frontend/pages/about_page.dart';
import 'package:universal_campaign_frontend/pages/coming_soon_page.dart';
import 'package:universal_campaign_frontend/pages/donate_page.dart';
import 'package:universal_campaign_frontend/pages/endorsements_page.dart';
import 'package:universal_campaign_frontend/pages/error_page.dart';
import 'package:universal_campaign_frontend/pages/home_page.dart';
import 'package:universal_campaign_frontend/pages/issues_page.dart';
import 'package:universal_campaign_frontend/pages/privacy_policy_page.dart';
import 'package:universal_campaign_frontend/services/config_service.dart';

void main() {
  setUrlStrategy(const HashUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<CampaignConfig> _campaignConfigFuture;

  @override
  void initState() {
    super.initState();
    _campaignConfigFuture = _loadConfig();
  }

  Future<CampaignConfig> _loadConfig() async {
    final campaignId = Uri.base.queryParameters['campaign'] ?? await ConfigService.getDefaultCampaignId();
    return ConfigService.loadCampaignConfig(campaignId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CampaignConfig>(
      future: _campaignConfigFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final config = snapshot.data!;
          return buildApp(config);
        } else if (snapshot.hasError) {
          return ErrorPage(errorMessage: snapshot.error.toString(), config: null);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildApp(CampaignConfig config) {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomePage(config: config),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => AboutPage(config: config),
        ),
        GoRoute(
          path: '/coming-soon',
          builder: (context, state) => ComingSoonPage(config: config),
        ),
        GoRoute(
          path: '/donate',
          builder: (context, state) => DonatePage(config: config),
        ),
        GoRoute(
          path: '/endorsements',
          builder: (context, state) => EndorsementsPage(config: config),
        ),
        GoRoute(
          path: '/issues',
          builder: (context, state) => IssuesPage(config: config),
        ),
        GoRoute(
          path: '/privacy-policy',
          builder: (context, state) => PrivacyPolicyPage(config: config),
        ),
      ],
    );

    return MaterialApp.router(
      title: config.content.siteTitle,
      theme: _buildTheme(config),
      routerConfig: router,
    );
  }

  ThemeData _buildTheme(CampaignConfig config) {
    Color primaryColor = Color(int.parse(config.theme.primaryColor.substring(1, 7), radix: 16) + 0xFF000000);
    Color secondaryColor = Color(int.parse(config.theme.secondaryColor.substring(1, 7), radix: 16) + 0xFF000000);
    Color backgroundColor = Color(int.parse(config.theme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000);
    Color textColor = Color(int.parse(config.theme.textColor.substring(1, 7), radix: 16) + 0xFF000000);

    final TextTheme appTextTheme = TextTheme(
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
}
