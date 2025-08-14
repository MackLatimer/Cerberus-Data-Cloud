class ComingSoonPageContent {
  final String title;
  final String message;

  ComingSoonPageContent({
    required this.title,
    required this.message,
  });

  factory ComingSoonPageContent.fromJson(Map<String, dynamic> json) {
    return ComingSoonPageContent(
      title: json['title'],
      message: json['message'],
    );
  }
}
