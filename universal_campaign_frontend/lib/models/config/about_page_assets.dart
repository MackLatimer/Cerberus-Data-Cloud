class AboutPageAssets {
  final String heroImagePath;
  final String bioImage1Path;
  final String bioImage2Path;
  final String bioImage3Path;

  AboutPageAssets({
    required this.heroImagePath,
    required this.bioImage1Path,
    required this.bioImage2Path,
    required this.bioImage3Path,
  });

  factory AboutPageAssets.fromJson(Map<String, dynamic> json) {
    return AboutPageAssets(
      heroImagePath: json['heroImagePath'],
      bioImage1Path: json['bioImage1Path'],
      bioImage2Path: json['bioImage2Path'],
      bioImage3Path: json['bioImage3Path'],
    );
  }
}
