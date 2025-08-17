class FooterContent {
  final String paidForText;
  final String? facebookLink;
  final String? instagramLink;
  final String? xLink;
  final String? linkedinLink;
  final String? youtubeLink;

  FooterContent({
    required this.paidForText,
    this.facebookLink,
    this.instagramLink,
    this.xLink,
    this.linkedinLink,
    this.youtubeLink,
  });

  factory FooterContent.fromJson(Map<String, dynamic> json) {
    return FooterContent(
      paidForText: json['paidForText'] ?? '',
      facebookLink: json['facebookLink'],
      instagramLink: json['instagramLink'],
      xLink: json['xLink'],
      linkedinLink: json['linkedinLink'],
      youtubeLink: json['youtubeLink'],
    );
  }
}
