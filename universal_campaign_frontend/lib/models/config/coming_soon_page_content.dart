class ComingSoonPageContent {
  final String title;
  final String subtitle;

  ComingSoonPageContent({
    required this.title,
    required this.subtitle,
  });

  factory ComingSoonPageContent.fromJson(Map<String, dynamic> json) {
    return ComingSoonPageContent(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }
}