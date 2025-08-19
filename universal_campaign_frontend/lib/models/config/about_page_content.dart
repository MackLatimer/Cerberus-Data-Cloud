class AboutPageContent {
  final String appBarTitle;
  final String heroImagePath;
  final String bioTitle;
  final String bioParagraph1;
  final String bioParagraph2;
  final String bioParagraph3;
  final String bioImage1Path;
  final String bioImage2Path;
  final String bioImage3Path;

  AboutPageContent({
    required this.appBarTitle,
    required this.heroImagePath,
    required this.bioTitle,
    required this.bioParagraph1,
    required this.bioParagraph2,
    required this.bioParagraph3,
    required this.bioImage1Path,
    required this.bioImage2Path,
    required this.bioImage3Path,
  });

  factory AboutPageContent.fromJson(Map<String, dynamic> json) {
    return AboutPageContent(
      appBarTitle: json['appBarTitle'] ?? '',
      heroImagePath: json['heroImagePath'] ?? '',
      bioTitle: json['bioTitle'] ?? '',
      bioParagraph1: json['bioParagraph1'] ?? '',
      bioParagraph2: json['bioParagraph2'] ?? '',
      bioParagraph3: json['bioParagraph3'] ?? '',
      bioImage1Path: json['bioImage1Path'] ?? '',
      bioImage2Path: json['bioImage2Path'] ?? '',
      bioImage3Path: json['bioImage3Path'] ?? '',
    );
  }
}
