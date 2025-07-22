import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/src/theme/theme.dart';

class AppTypography {
  static TextTheme get textTheme => TextTheme(
        displayLarge: GoogleFonts.bebasNeue(
            fontSize: 152,
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.bebasNeue(
            fontSize: 122,
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.bebasNeue(
            fontSize: 98,
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.bebasNeue(
            fontSize: 78,
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.bebasNeue(
            fontSize: 62,
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.bebasNeue(
            fontSize: 50,
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.bebasNeue(
            fontSize: 40,
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold),
        titleMedium: GoogleFonts.bebasNeue(
            fontSize: 32,
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold),
        titleSmall: GoogleFonts.bebasNeue(
            fontSize: 25,
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.tinos(
          fontSize: 20,
          color: AppColors.onBackground,
        ),
        bodyMedium: GoogleFonts.tinos(
          fontSize: 16,
          color: AppColors.onBackground,
        ),
        bodySmall: GoogleFonts.tinos(
          fontSize: 12.8,
          color: AppColors.onBackground,
        ),
        labelLarge: GoogleFonts.bebasNeue(
            fontSize: 20,
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold),
        labelMedium: GoogleFonts.bebasNeue(
            fontSize: 16, fontWeight: FontWeight.bold),
        labelSmall: GoogleFonts.bebasNeue(
            fontSize: 12.8, fontWeight: FontWeight.bold),
      );
}
