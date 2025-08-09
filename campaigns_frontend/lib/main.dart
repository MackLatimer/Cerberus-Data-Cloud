import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campaigns_frontend/src/pages/about_page.dart';
import 'package:campaigns_frontend/src/pages/coming_soon_page.dart';
import 'package:campaigns_frontend/src/pages/donate_page.dart';
import 'package:campaigns_frontend/src/pages/endorsements_page.dart';
import 'package:campaigns_frontend/src/pages/home_page.dart';
import 'package:campaigns_frontend/src/pages/issues_page.dart';
import 'package:campaigns_frontend/src/pages/privacy_policy_page.dart';
import 'package:campaigns_frontend/src/providers.dart';
import 'package:campaign_config/campaign_config.dart';

void main({required CampaignConfig config}) {
  setUrlStrategy(const HashUrlStrategy());
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(
    ProviderScope(
      overrides: [
        campaignConfigProvider.overrideWithValue(config),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(campaignConfigProvider);

    final router = GoRouter(
      initialLocation: '/coming-soon',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/coming-soon',
          builder: (context, state) => const ComingSoonPage(),
        ),
        GoRoute(
          path: '/issues',
          builder: (context, state) => const IssuesPage(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutPage(),
        ),
        GoRoute(
          path: '/endorsements',
          builder: (context, state) => const EndorsementsPage(),
        ),
        GoRoute(
          path: '/donate',
          builder: (context, state) => const DonatePage(),
        ),
        GoRoute(
          path: '/privacy-policy',
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
      ],
    );

    final Color primaryColor = config.primaryColor;
    final Color secondaryColor = config.secondaryColor;
    const Color backgroundColor = Color(0xFFFFFFFF); // White
    const Color textColor = Color(0xFF000000); // Black

    final TextTheme appTextTheme = TextTheme(
      displayLarge: TextStyle(fontFamily: config.fontHeader, fontSize: 152, color: textColor, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: config.fontHeader, fontSize: 122, color: textColor, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: config.fontHeader, fontSize: 98, color: textColor, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: config.fontHeader, fontSize: 78, color: textColor, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontFamily: config.fontHeader, fontSize: 62, color: textColor, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontFamily: config.fontHeader, fontSize: 50, color: textColor, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontFamily: config.fontHeader, fontSize: 40, color: textColor, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontFamily: config.fontHeader, fontSize: 32, color: textColor, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(fontFamily: config.fontHeader, fontSize: 25, color: textColor, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontFamily: config.fontBody, fontSize: 20, color: textColor),
      bodyMedium: TextStyle(fontFamily: config.fontBody, fontSize: 16, color: textColor),
      bodySmall: TextStyle(fontFamily: config.fontBody, fontSize: 12.8, color: textColor),
      labelLarge: TextStyle(fontFamily: config.fontHeader, fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontFamily: config.fontHeader, fontSize: 16, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(fontFamily: aconfig.fontHeader, fontSize: 12.8, fontWeight: FontWeight.bold),
    );

    return MaterialApp.router(
      title: config.campaignName,
      theme: ThemeData(
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
      ),
      routerConfig: router,
    );
  }
}
