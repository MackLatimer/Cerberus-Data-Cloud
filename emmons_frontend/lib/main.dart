import 'package:emmons_frontend/api/campaign_service.dart';
import 'package:emmons_frontend/config/campaign_config.dart';
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

// Provider to hold the campaign configuration
final campaignProvider = Provider<CampaignConfig>((ref) {
  // This will be replaced by the actual loaded config.
  // Throwing an error here to ensure it's overridden in the ProviderScope.
  throw UnimplementedError();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(const HashUrlStrategy());
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // In a real app, you'd get the identifier from the hostname.
  // For now, we hardcode it to "emmons".
  const campaignIdentifier = 'emmons';
  final campaignConfig = await CampaignService().fetchConfigFor(campaignIdentifier);

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

    return MaterialApp.router(
      title: campaignConfig.siteTitle, // Using dynamic site title
      theme: createAppTheme(campaignConfig), // Using the dynamic theme generator
      routerConfig: router,
    );
  }
}
