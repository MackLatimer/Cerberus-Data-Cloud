class HomePageAssets {
  final String logoPath;
  final String heroImagePath;

  HomePageAssets({
    required this.logoPath,
    required this.heroImagePath,
  });

  factory HomePageAssets.fromJson(Map<String, dynamic> json) {
    return HomePageAssets(
      logoPath: json['logoPath'] ?? '',
      heroImagePath: json['heroImagePath'] ?? '',
    );
  }
}
