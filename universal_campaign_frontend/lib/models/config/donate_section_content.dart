class DonateSectionContent {
  final String callToActionText;
  final String buttonText;

  DonateSectionContent({
    required this.callToActionText,
    required this.buttonText,
  });

  factory DonateSectionContent.fromJson(Map<String, dynamic> json) {
    return DonateSectionContent(
      callToActionText: json['callToActionText'] ?? '',
      buttonText: json['buttonText'] ?? '',
    );
  }
}
