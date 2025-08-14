class CommonAppBarAssets {
  final String logoPath;

  CommonAppBarAssets({
    required this.logoPath,
  });

  factory CommonAppBarAssets.fromJson(Map<String, dynamic> json) {
    return CommonAppBarAssets(
      logoPath: json['logoPath'],
    );
  }
}
