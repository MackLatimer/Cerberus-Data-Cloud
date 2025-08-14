class EndorsementsPageAssets {
  final String heroImagePath;

  EndorsementsPageAssets({
    required this.heroImagePath,
  });

  factory EndorsementsPageAssets.fromJson(Map<String, dynamic> json) {
    return EndorsementsPageAssets(
      heroImagePath: json['heroImagePath'],
    );
  }
}
