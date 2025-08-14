class IssueSectionContent {
  final String title;
  final String description;
  final String? backgroundColor;
  final String? textColor;
  final String imagePath;

  IssueSectionContent({
    required this.title,
    required this.description,
    this.backgroundColor,
    this.textColor,
    required this.imagePath,
  });

  factory IssueSectionContent.fromJson(Map<String, dynamic> json) {
    return IssueSectionContent(
      title: json['title'],
      description: json['description'],
      backgroundColor: json['backgroundColor'],
      textColor: json['textColor'],
      imagePath: json['imagePath'],
    );
  }
}
