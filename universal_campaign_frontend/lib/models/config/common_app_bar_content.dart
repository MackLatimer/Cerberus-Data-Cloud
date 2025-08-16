import 'package:universal_campaign_frontend/models/config/nav_item.dart';

class CommonAppBarContent {
  final String logoPath;
  final double logoWidth; // Added
  final double logoHeight; // Added
  final List<NavItem> navItems;

  CommonAppBarContent({
    required this.logoPath,
    required this.logoWidth, // Added
    required this.logoHeight, // Added
    required this.navItems,
  });

  factory CommonAppBarContent.fromJson(Map<String, dynamic> json) {
    return CommonAppBarContent(
      logoPath: json['logoPath'] ?? '',
      logoWidth: (json['logoWidth'] as num? ?? 0.0).toDouble(), // Added
      logoHeight: (json['logoHeight'] as num? ?? 0.0).toDouble(), // Added
      navItems: (json['navItems'] as List? ?? [])
          .map((i) => NavItem.fromJson(i))
          .toList(),
    );
  }
}
