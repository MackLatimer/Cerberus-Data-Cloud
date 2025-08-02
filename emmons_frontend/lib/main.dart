import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart'; // Import for setUrlStrategy
import 'dart:ui_web' as ui show HashUrlStrategy, platformViewRegistry;
import 'dart:js_interop';
import 'package:candidate_website/src/widgets/stripe_element.dart';
import 'package:candidate_website/src/pages/about_page.dart';
import 'package:candidate_website/src/pages/coming_soon_page.dart';
import 'package:candidate_website/src/pages/donate_page.dart';
import 'package:candidate_website/src/pages/endorsements_page.dart';
import 'package:candidate_website/src/pages/home_page.dart';
import 'package:candidate_website/src/pages/issues_page.dart';
import 'package:candidate_website/src/pages/privacy_policy_page.dart';


void main() {
  // Use hash-based URL strategy for web
  setUrlStrategy(const HashUrlStrategy());
  GoRouter.optionURLReflectsImperativeAPIs = true;

    // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    'card-element',
        (int viewId) => StripeElement((getProperty(globalThis, 'elements'.toJS) as JSObject).callMethod('create'.toJS, ['card'.toJS as JSAny])).element,
  );

  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/coming-soon',
      routes: [
        GoRoute(
          path: '/',
          redirect: (_, __) => '/home',
        ),
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

    const Color primaryColor = Color(0xFF002663); // Dark Blue
    const Color secondaryColor = Color(0xFFA01124); // Red
    const Color backgroundColor = Color(0xFFFFFFFF); // Black
    const Color textColor = Color(0xFF000000); // White

    const TextTheme appTextTheme = TextTheme(
      displayLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 152, color: textColor, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 122, color: textColor, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 98, color: textColor, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 78, color: textColor, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 62, color: textColor, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 50, color: textColor, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 40, color: textColor, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 32, color: textColor, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 25, color: textColor, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontFamily: 'Tinos', fontSize: 20, color: textColor),
      bodyMedium: TextStyle(fontFamily: 'Tinos', fontSize: 16, color: textColor),
      bodySmall: TextStyle(fontFamily: 'Tinos', fontSize: 12.8, color: textColor),
      labelLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), // White for buttons on colored background
      labelMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 16, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 12.8, fontWeight: FontWeight.bold),
    );

    return MaterialApp.router(
      title: 'Curtis Emmons for County Commissioner',
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
            textStyle: appTextTheme.labelLarge, // Ensure this uses the white color defined in labelLarge
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: secondaryColor, // Use secondary color for text buttons for contrast
            textStyle: appTextTheme.labelMedium?.copyWith(color: secondaryColor),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}