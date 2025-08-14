class CommonAppBarAssets {
  final String logoPath;
  final double logoWidth;
  final double logoHeight;

  CommonAppBarAssets({
    required this.logoPath,
    required this.logoWidth,
    required this.logoHeight,
  });

  factory CommonAppBarAssets.fromJson(Map<String, dynamic> json) {
    return CommonAppBarAssets(
      logoPath: json['logoPath'],
      logoWidth: (json['logoWidth'] as num).toDouble(),
      logoHeight: (json['logoHeight'] as num).toDouble(),
    );
  }
}