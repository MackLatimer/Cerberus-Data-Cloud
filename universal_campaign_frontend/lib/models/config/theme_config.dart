import 'package:universal_campaign_frontend/models/config/home_page_section_theme.dart';

class ThemeConfig {
  final String primaryColor;
  final String secondaryColor;
  final String backgroundColor;
  final String textColor;
  final String fontFamily;
  final String secondaryFontFamily;
  final double navBarItemFontSize;
  final bool usePageTransitions;
  final HomePageSectionTheme issuesSectionTheme;
  final HomePageSectionTheme aboutMeSectionTheme;
  final HomePageSectionTheme endorsementsSectionTheme;
  final HomePageSectionTheme donateSectionTheme;

  ThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.fontFamily,
    required this.secondaryFontFamily,
    required this.navBarItemFontSize,
    required this.usePageTransitions,
    required this.issuesSectionTheme,
    required this.aboutMeSectionTheme,
    required this.endorsementsSectionTheme,
    required this.donateSectionTheme,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      primaryColor: json['primaryColor'] ?? '',
      secondaryColor: json['secondaryColor'] ?? '',
      backgroundColor: json['backgroundColor'] ?? '',
      textColor: json['textColor'] ?? '',
      fontFamily: json['fontFamily'] ?? '',
      secondaryFontFamily: json['secondaryFontFamily'] ?? '',
      navBarItemFontSize: (json['navBarItemFontSize'] as num?)?.toDouble() ?? 16.0,
      usePageTransitions: json['usePageTransitions'] ?? true,
      issuesSectionTheme: HomePageSectionTheme.fromJson(json['issuesSectionTheme'] ?? {}),
      aboutMeSectionTheme: HomePageSectionTheme.fromJson(json['aboutMeSectionTheme'] ?? {}),
      endorsementsSectionTheme: HomePageSectionTheme.fromJson(json['endorsementsSectionTheme'] ?? {}),
      donateSectionTheme: HomePageSectionTheme.fromJson(json['donateSectionTheme'] ?? {}),
    );
  }
}

