import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'pages/home/home_page.dart';
import 'pages/about/about_page.dart';
import 'pages/contact/contact_page.dart';
import 'pages/report/report_page.dart';
import 'pages/upload/upload_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51Rnnfv4brLkKMnfT9dQISZb1hLmvQMVq3nr8Ymb67lqFQ4JwJkTrc92dRUXKYvYs3tSMeYZkTgIkKJxLsOmjqTN800f2UFiJiT';
  runApp(const MyApp());
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return RootLayout(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: '/about',
          builder: (BuildContext context, GoRouterState state) {
            return const AboutPage();
          },
        ),
        GoRoute(
          path: '/contact',
          builder: (BuildContext context, GoRouterState state) {
            return const ContactPage();
          },
        ),
        GoRoute(
          path: '/report',
          builder: (BuildContext context, GoRouterState state) {
            return const ReportPage();
          },
        ),
        GoRoute(
          path: '/upload',
          builder: (BuildContext context, GoRouterState state) {
            return const UploadPage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Cerberus Campaigns',
      theme: _buildAppTheme(),
    );
  }
}

ThemeData _buildAppTheme() {
  const Color primaryBlack = Color(0xFF000000);
  const Color primaryRed = Color(0xFFA6192E); // Keep for specific uses if needed, e.g. error color
  const Color primaryBlue = Color(0xFF003B71); // Seed color
  const Color primaryWhite = Color(0xFFFFFFFF); // Keep for specific uses if needed

  const String fontLeagueSpartan = 'LeagueSpartan';
  const String fontSignika = 'Signika';

  final theme = ThemeData(
    useMaterial3: true, // Enable Material 3
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      // Let M3 derive most colors. We can override specific ones if needed.
      // primary: primaryBlue, // Example: if M3 derivation isn't quite right
      // secondary: primaryRed, // Example
      error: primaryRed, // Keep custom error color if desired
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: primaryBlack,
  );

  // Apply M3-aligned component themes
  return theme.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: primaryWhite,
      elevation: 0.0, // M3 often uses 0 or low elevation
      toolbarHeight: 200,
      surfaceTintColor: theme.colorScheme.surfaceTint, // Recommended for M3 app bars
      iconTheme: const IconThemeData(color: primaryWhite), // Ensure icons match foreground
      actionsIconTheme: const IconThemeData(color: primaryWhite), // Ensure action icons match
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: primaryWhite,
          fontFamily: fontLeagueSpartan,
          fontSize: 44.0,
          fontWeight: FontWeight.bold),
    ),
    textTheme: TextTheme(
      // M3 Type Scale using LeagueSpartan and Signika
      displayLarge: TextStyle(fontFamily: fontLeagueSpartan, fontSize: 57.0, fontWeight: FontWeight.bold, letterSpacing: -0.25, height: 64.0/57.0, color: theme.colorScheme.onSurface),
      displayMedium: TextStyle(fontFamily: fontLeagueSpartan, fontSize: 45.0, fontWeight: FontWeight.bold, letterSpacing: 0.0, height: 52.0/45.0, color: theme.colorScheme.onSurface),
      displaySmall: TextStyle(fontFamily: fontLeagueSpartan, fontSize: 36.0, fontWeight: FontWeight.bold, letterSpacing: 0.0, height: 44.0/36.0, color: theme.colorScheme.onSurface),

      headlineLarge: TextStyle(fontFamily: 'LeagueSpartan', fontSize: 44.0, fontWeight: FontWeight.bold, color: Colors.white),
      headlineSmall: TextStyle(fontFamily: 'LeagueSpartan', fontSize: 44.0, fontWeight: FontWeight.bold, color: Colors.white),

      titleLarge: TextStyle(fontFamily: fontLeagueSpartan, fontSize: 22.0, fontWeight: FontWeight.bold, letterSpacing: 0.0, height: 28.0/22.0, color: theme.colorScheme.onSurface), // Used for AppBar title by default in M3
      titleMedium: TextStyle(fontFamily: fontSignika, fontSize: 18.0, fontWeight: FontWeight.w500, letterSpacing: 0.15, height: 24.0/16.0, color: theme.colorScheme.onSurface),
      titleSmall: TextStyle(fontFamily: fontSignika, fontSize: 18.0, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 20.0/14.0, color: theme.colorScheme.onSurface),

      bodyLarge: TextStyle(fontFamily: 'Signika', fontSize: 18.0, color: Colors.white),
      bodyMedium: TextStyle(fontFamily: fontSignika, fontSize: 18.0, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 20.0/14.0, color: theme.colorScheme.onSurface),
      bodySmall: TextStyle(fontFamily: fontSignika, fontSize: 18.0, fontWeight: FontWeight.w400, letterSpacing: 0.4, height: 16.0/12.0, color: theme.colorScheme.onSurfaceVariant),

      labelLarge: TextStyle(fontFamily: 'Signika', fontSize: 18.0, color: Colors.white), // Default for ElevatedButton
      labelMedium: TextStyle(fontFamily: fontSignika, fontSize: 18.0, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 16.0/12.0, color: theme.colorScheme.onSurface),
      labelSmall: TextStyle(fontFamily: fontSignika, fontSize: 18.0, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 16.0/11.0, color: theme.colorScheme.onSurfaceVariant),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        textStyle: theme.textTheme.labelLarge?.copyWith(fontFamily: fontSignika),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.white, width: 3.0)),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0), // More rounded M3 style
        borderSide: BorderSide(color: theme.colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder( // Explicitly define enabled border for consistency
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: theme.colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
      ),
      labelStyle: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontFamily: fontSignika),
      floatingLabelStyle: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary, fontFamily: fontSignika),
    ),
    cardTheme: CardThemeData(
      color: theme.colorScheme.surfaceContainerLow,
      elevation: 1.0,
      shadowColor: theme.colorScheme.shadow,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      elevation: 0.0,
    ),
  );
}

class RootLayout extends StatefulWidget {
  const RootLayout({required this.child, super.key});

  final Widget child;

  @override
  State<RootLayout> createState() => _RootLayoutState();
}

class _RootLayoutState extends State<RootLayout> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/Slow_Blue_Smoke.mov')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the video plays.
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Stack(
          children: <Widget>[
            _controller.value.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : Container(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Cerberus Logo Final.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Cerberus Campaigns',
                      style: theme.appBarTheme.titleTextStyle,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => context.go('/'),
                          child: Text('Home', style: TextStyle(color: theme.appBarTheme.foregroundColor, fontWeight: FontWeight.bold, fontSize: 24)),
                        ),
                        TextButton(
                          onPressed: () => context.go('/about'),
                          child: Text('About', style: TextStyle(color: theme.appBarTheme.foregroundColor, fontWeight: FontWeight.bold, fontSize: 24)),
                        ),
                        TextButton(
                          onPressed: () => context.go('/contact'),
                          child: Text('Contact', style: TextStyle(color: theme.appBarTheme.foregroundColor, fontWeight: FontWeight.bold, fontSize: 24)),
                        ),
                        TextButton(
                          onPressed: () => context.go('/report'),
                          child: Text('Report', style: TextStyle(color: theme.appBarTheme.foregroundColor, fontWeight: FontWeight.bold, fontSize: 24)),
                        ),
                        TextButton(
                          onPressed: () => context.go('/upload'),
                          child: Text('Upload', style: TextStyle(color: theme.appBarTheme.foregroundColor, fontWeight: FontWeight.bold, fontSize: 24)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: widget.child,
    );
  }
}
