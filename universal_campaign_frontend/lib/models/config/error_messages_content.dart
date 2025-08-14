class ErrorMessagesContent {
  final String submitFormError;
  final String submitFormGenericError;
  final String createPaymentIntentFailed;
  final String createPaymentIntentError;
  final String stripeError;
  final String unforeseenError;
  final String submitDetailsFailed;
  final String submitDetailsError;

  ErrorMessagesContent({
    required this.submitFormError,
    required this.submitFormGenericError,
    required this.createPaymentIntentFailed,
    required this.createPaymentIntentError,
    required this.stripeError,
    required this.unforeseenError,
    required this.submitDetailsFailed,
    required this.submitDetailsError,
  });

  factory ErrorMessagesContent.fromJson(Map<String, dynamic> json) {
    return ErrorMessagesContent(
      submitFormError: json['submitFormError'],
      submitFormGenericError: json['submitFormGenericError'],
      createPaymentIntentFailed: json['createPaymentIntentFailed'],
      createPaymentIntentError: json['createPaymentIntentError'],
      stripeError: json['stripeError'],
      unforeseenError: json['unforeseenError'],
      submitDetailsFailed: json['submitDetailsFailed'],
      submitDetailsError: json['submitDetailsError'],
    );
  }
}
