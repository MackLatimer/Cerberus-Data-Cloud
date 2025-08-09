import 'package:emmons_frontend/config/campaign_config.dart';
import 'package:flutter/material.dart';

// Helper function to convert a hex string to a Color
Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

ThemeData createAppTheme(CampaignConfig config) {
  final primaryColor = _colorFromHex(config.theme.primaryColor);
  final secondaryColor = _colorFromHex(config.theme.secondaryColor);
  final backgroundColor = const Color(0xFFFFFFFF); // Assuming a standard white background
  final textColor = const Color(0xFF000000);       // Assuming standard black text

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
    bodyLarge: const TextStyle(fontFamily: 'Tinos', fontSize: 20, color: textColor), // Assuming a standard body font
    bodyMedium: const TextStyle(fontFamily: 'Tinos', fontSize: 16, color: textColor),
    bodySmall: const TextStyle(fontFamily: 'Tinos', fontSize: 12.8, color: textColor),
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
