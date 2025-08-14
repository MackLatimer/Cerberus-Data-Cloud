class PrivacyPolicyPageContent {
  final String appBarTitle;
  final String title;
  final String content;

  PrivacyPolicyPageContent({
    required this.appBarTitle,
    required this.title,
    required this.content,
  });

  factory PrivacyPolicyPageContent.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyPageContent(
      appBarTitle: json['appBarTitle'],
      title: json['title'],
      content: json['content'],
    );
  }
}
