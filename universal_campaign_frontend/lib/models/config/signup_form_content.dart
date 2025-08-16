class SignupFormContent {
  final String title;
  final String endorseText;
  final String getInvolvedText;
  final String automatedMessagingText;
  final String emailOptInText;
  final String legalText;
  final String submitButtonText;
  final String privacyPolicyText;

  SignupFormContent({
    required this.title,
    required this.endorseText,
    required this.getInvolvedText,
    required this.automatedMessagingText,
    required this.emailOptInText,
    required this.legalText,
    required this.submitButtonText,
    required this.privacyPolicyText,
  });

  factory SignupFormContent.fromJson(Map<String, dynamic> json) {
    return SignupFormContent(
      title: json['title'] ?? '',
      endorseText: json['endorseText'] ?? '',
      getInvolvedText: json['getInvolvedText'] ?? '',
      automatedMessagingText: json['automatedMessagingText'] ?? '',
      emailOptInText: json['emailOptInText'] ?? '',
      legalText: json['legalText'] ?? '',
      submitButtonText: json['submitButtonText'] ?? '',
      privacyPolicyText: json['privacyPolicyText'] ?? '',
    );
  }
}