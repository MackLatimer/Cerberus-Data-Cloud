class FooterContent {
  final String paidForText;

  FooterContent({
    required this.paidForText,
  });

  factory FooterContent.fromJson(Map<String, dynamic> json) {
    return FooterContent(
      paidForText: json['paidForText'] ?? '',
    );
  }
}
