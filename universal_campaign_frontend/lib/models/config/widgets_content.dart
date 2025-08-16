import 'package:universal_campaign_frontend/models/config/signup_form_content.dart';

class WidgetsContent {
  final SignupFormContent signupForm;

  WidgetsContent({
    required this.signupForm,
  });

  factory WidgetsContent.fromJson(Map<String, dynamic> json) {
    return WidgetsContent(
      signupForm: SignupFormContent.fromJson(json['signupForm'] ?? {}),
    );
  }
}
