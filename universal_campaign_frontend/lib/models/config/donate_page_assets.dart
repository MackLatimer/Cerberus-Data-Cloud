class DonatePageAssets {
  final String heroImagePath;

  DonatePageAssets({
    required this.heroImagePath,
  });

  factory DonatePageAssets.fromJson(Map<String, dynamic> json) {
    return DonatePageAssets(
      heroImagePath: json['heroImagePath'] ?? '',
    );
  }
}
