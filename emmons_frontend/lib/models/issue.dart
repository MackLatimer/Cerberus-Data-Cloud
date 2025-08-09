class Issue {
  final String title;
  final String description;
  final String imageUrl;

  Issue({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
