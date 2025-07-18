import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:candidate_website/src/pages/about_page.dart';
import 'package:candidate_website/src/pages/donate_page.dart';
import 'package:candidate_website/src/pages/endorsements_page.dart';
import 'package:candidate_website/src/pages/home_page.dart';
import 'package:candidate_website/src/pages/issues_page.dart';
import 'package:candidate_website/src/pages/privacy_policy_page.dart'; // Import the new page

// Define the routes for the application
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
    ),
    GoRoute(
      path: '/issues',
      pageBuilder: (context, state) => const NoTransitionPage(child: IssuesPage()),
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) => const NoTransitionPage(child: AboutPage()),
    ),
    GoRoute(
      path: '/endorsements',
      pageBuilder: (context, state) => const NoTransitionPage(child: EndorsementsPage()),
    ),
    GoRoute(
      path: '/donate',
      pageBuilder: (context, state) => const NoTransitionPage(child: DonatePage()),
    ),
    GoRoute( // Add Privacy Policy route
      path: '/privacy-policy',
      pageBuilder: (context, state) => const NoTransitionPage(child: PrivacyPolicyPage()),
    ),
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure URL strategy is set for web (removes hashbang #)
  GoRouter.optionURLReflectsImperativeAPIs = true;
  // Initialize Stripe with the key from compile-time variables.
  Stripe.publishableKey = const String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_YOUR_FALLBACK_TEST_KEY_HERE', // Fallback for local dev
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF002663); // Dark Blue
    const Color secondaryColor = Color(0xFFA01124); // Red
    const Color backgroundColor = Color(0xFFFFFFFF); // Black
    const Color textColor = Color(0xFF000000); // White

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.bebasNeue(fontSize: 152, color: textColor, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.bebasNeue(fontSize: 122, color: textColor, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.bebasNeue(fontSize: 98, color: textColor, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.bebasNeue(fontSize: 78, color: textColor, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.bebasNeue(fontSize: 62, color: textColor, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.bebasNeue(fontSize: 50, color: textColor, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.bebasNeue(fontSize: 40, color: textColor, fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.bebasNeue(fontSize: 32, color: textColor, fontWeight: FontWeight.bold),
      titleSmall: GoogleFonts.bebasNeue(fontSize: 25, color: textColor, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.tinos(fontSize: 20, color: textColor),
      bodyMedium: GoogleFonts.tinos(fontSize: 16, color: textColor),
      bodySmall: GoogleFonts.tinos(fontSize: 12.8, color: textColor),
      labelLarge: GoogleFonts.bebasNeue(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), // White for buttons on colored background
      labelMedium: GoogleFonts.bebasNeue(fontSize: 16, fontWeight: FontWeight.bold),
      labelSmall: GoogleFonts.bebasNeue(fontSize: 12.8, fontWeight: FontWeight.bold),
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
      routerConfig: _router,
    );
  }
}

// Simple placeholder page to verify routing - This can be removed now
// class PlaceholderPage extends StatelessWidget {
//   final String title;
//   const PlaceholderPage({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//          automaticallyImplyLeading: false, // Usually false for top-level routes if using a custom nav bar
//       ),
//       body: Center(
//         child: Text('This is the $title', style: Theme.of(context).textTheme.headlineSmall),
//       ),
//     );
//   }
// }
