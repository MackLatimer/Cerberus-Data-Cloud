import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_project/pages/home_page.dart';
import 'dart:io' if (dart.library.html) 'dart:html' as html;

void main() {
  if (kIsWeb) {
    // Set web-specific configurations if necessary
  }
  runApp(const CerberusApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    // Add other top-level routes here
    // e.g., GoRoute(path: '/voters', builder: ...),
  ],
);

class CerberusApp extends StatelessWidget {
  const CerberusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cerberus Campaigns',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A2342),
          brightness: Brightness.dark,
          primary: const Color(0xFF0A2342),
          secondary: const Color(0xFF2CA58D),
          background: const Color(0xFF000000),
          surface: const Color(0xFF1A2F4B), // For cards and dialogs
        ),
        scaffoldBackgroundColor: const Color(0xFF000000),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.bold),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}