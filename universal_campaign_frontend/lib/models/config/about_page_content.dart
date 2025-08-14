class AboutPageContent {
  final String appBarTitle;
  final String heroImagePath;
  final String bioTitle;
  final String bioParagraph1;
  final String bioParagraph2;
  final String bioParagraph3;

  AboutPageContent({
    required this.appBarTitle,
    required this.heroImagePath,
    required this.bioTitle,
    required this.bioParagraph1,
    required this.bioParagraph2,
    required this.bioParagraph3,
  });

  factory AboutPageContent.fromJson(Map<String, dynamic> json) {
    return AboutPageContent(
      appBarTitle: json['appBarTitle'],
      heroImagePath: json['heroImagePath'],
      bioTitle: json['bioTitle'],
      bioParagraph1: json['bioParagraph1'],
      bioParagraph2: json['bioParagraph2'],
      bioParagraph3: json['bioParagraph3'],
    );
  }
}
