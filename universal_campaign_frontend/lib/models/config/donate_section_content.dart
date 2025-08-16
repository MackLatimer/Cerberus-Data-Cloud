class DonateSectionContent {
  final String title;
  final String buttonText;

  DonateSectionContent({
    required this.title,
    required this.buttonText,
  });

  factory DonateSectionContent.fromJson(Map<String, dynamic> json) {
    return DonateSectionContent(
      title: json['title'] ?? '',
      buttonText: json['buttonText'] ?? '',
    );
  }
}
