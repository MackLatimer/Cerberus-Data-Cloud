import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
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
    );
  }
}
