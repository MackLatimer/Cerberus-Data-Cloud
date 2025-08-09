import 'dart:html' if (dart.library.io) 'dart:io';
import 'package:emmons_frontend/config/campaign_config.dart';
import 'package:emmons_frontend/config/campaigns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:emmons_frontend/ui/features/pages/about_page.dart';
import 'package:emmons_frontend/ui/features/pages/coming_soon_page.dart';
import 'package:emmons_frontend/ui/features/pages/donate_page.dart';
import 'package:emmons_frontend/ui/features/pages/endorsements_page.dart';
import 'package:emmons_frontend/ui/features/pages/home_page.dart';
import 'package:emmons_frontend/ui/features/pages/issues_page.dart';
import 'package:emmons_frontend/ui/features/pages/privacy_policy_page.dart';

// Provider to hold the campaign configuration.
// It is overridden in main() with the correct campaign config.
final campaignProvider = Provider<CampaignConfig>((ref) {
  // Return a default or throw an error if not overridden.
  // This ensures we always have a config.
  return campaignsByDomain['localhost']!;
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(const HashUrlStrategy());
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // Determine the campaign config based on the hostname.
  final String hostname = Uri.base.host;
  final CampaignConfig campaignConfig = campaignsByDomain[hostname] ?? campaignsByDomain['localhost']!;

  runApp(
    ProviderScope(
      overrides: [
        campaignProvider.overrideWithValue(campaignConfig),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the campaign config from the provider.
    final campaignConfig = ref.watch(campaignProvider);

    final router = GoRouter(
      initialLocation: '/home', // Changed to /home as a better default
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

    return MaterialApp.router(
      title: campaignConfig.siteTitle,
      theme: campaignConfig.theme, // Use the theme directly from the config
      routerConfig: router,
    );
  }
}
