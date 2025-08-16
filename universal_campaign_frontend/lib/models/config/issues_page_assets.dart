class IssuesPageAssets {
  final String heroImagePath;

  IssuesPageAssets({
    required this.heroImagePath,
  });

  factory IssuesPageAssets.fromJson(Map<String, dynamic> json) {
    return IssuesPageAssets(
      heroImagePath: json['heroImagePath'] ?? '',
    );
  }
}
