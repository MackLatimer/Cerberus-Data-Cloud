import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:campaign_feature/campaign_feature.dart';
import 'package:data_portal_feature/data_portal_feature.dart';
import 'package:report_feature/report_feature.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Unified Frontend',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
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
    GoRoute(
      path: '/upload',
      builder: (context, state) => const UploadPage(),
    ),
    GoRoute(
      path: '/report',
      builder: (context, state) => const ReportPage(),
    ),
  ],
);
