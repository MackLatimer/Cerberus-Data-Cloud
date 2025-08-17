class DonatePageContent {
  final String appBarTitle;
  final String heroImagePath; // Added
  final String title;
  final String subtitle;
  final String mailDonationText;
  final String thankYouText;

  DonatePageContent({
    required this.appBarTitle,
    required this.heroImagePath, // Added
    required this.title,
    required this.subtitle,
    required this.mailDonationText,
    required this.thankYouText,
  });

  factory DonatePageContent.fromJson(Map<String, dynamic> json) {
    return DonatePageContent(
      appBarTitle: json['appBarTitle'] ?? '',
      heroImagePath: json['heroImagePath'] ?? '', // Added
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      mailDonationText: json['mailDonationText'] ?? '',
      thankYouText: json['thankYouText'] ?? '',
    );
  }
}
