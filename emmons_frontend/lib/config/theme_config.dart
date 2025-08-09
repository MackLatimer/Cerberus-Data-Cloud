class ThemeConfig {
  final String primaryColor;
  final String secondaryColor;
  final String fontFamily;
  final String logoUrl;

  ThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.fontFamily,
    required this.logoUrl,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      fontFamily: json['fontFamily'] as String,
      logoUrl: json['logoUrl'] as String,
    );
  }
}
