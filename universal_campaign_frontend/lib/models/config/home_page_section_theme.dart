class HomePageSectionTheme {
  final String backgroundColor;
  final String textColor;
  final String buttonColor;
  final String buttonTextColor;

  HomePageSectionTheme({
    required this.backgroundColor,
    required this.textColor,
    required this.buttonColor,
    required this.buttonTextColor,
  });

  factory HomePageSectionTheme.fromJson(Map<String, dynamic> json) {
    return HomePageSectionTheme(
      backgroundColor: json['backgroundColor'] ?? '',
      textColor: json['textColor'] ?? '',
      buttonColor: json['buttonColor'] ?? '',
      buttonTextColor: json['buttonTextColor'] ?? '',
    );
  }
}
