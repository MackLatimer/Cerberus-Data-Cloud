class ErrorPageContent {
  final String appBarTitle;
  final String errorMessagePrefix;

  ErrorPageContent({
    required this.appBarTitle,
    required this.errorMessagePrefix,
  });

  factory ErrorPageContent.fromJson(Map<String, dynamic> json) {
    return ErrorPageContent(
      appBarTitle: json['appBarTitle'] ?? '',
      errorMessagePrefix: json['errorMessagePrefix'] ?? '',
    );
  }
}
