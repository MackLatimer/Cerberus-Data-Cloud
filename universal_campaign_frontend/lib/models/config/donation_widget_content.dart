import 'package:universal_campaign_frontend/models/config/error_messages_content.dart';

class DonationWidgetContent {
  final String amountSelectionPrompt;
  final String customAmountLabel;
  final String continueButtonText;
  final String firstNameValidation;
  final String lastNameValidation;
  final String addressValidation;
  final String addressLine2Label;
  final String cityLabel;
  final String stateLabel;
  final String zipCodeLabel;
  final String employerLabel;
  final String occupationLabel;
  final String proceedToPaymentButtonText;
  final String coverFeesText;
  final String recurringDonationText;
  final String emailLabel;
  final String phoneLabel;
  final String emailValidationEmpty;
  final String emailValidationInvalid;
  final String contactEmailText;
  final String contactPhoneText;
  final String contactMailText;
  final String contactSmsText;
  final String submitButtonText;
  final String successMessage;
  final ErrorMessagesContent errorMessages;
  final List<int> donationAmounts;

  DonationWidgetContent({
    required this.amountSelectionPrompt,
    required this.customAmountLabel,
    required this.continueButtonText,
    required this.firstNameValidation,
    required this.lastNameValidation,
    required this.addressValidation,
    required this.addressLine2Label,
    required this.cityLabel,
    required this.stateLabel,
    required this.zipCodeLabel,
    required this.employerLabel,
    required this.occupationLabel,
    required this.proceedToPaymentButtonText,
    required this.coverFeesText,
    required this.recurringDonationText,
    required this.emailLabel,
    required this.phoneLabel,
    required this.emailValidationEmpty,
    required this.emailValidationInvalid,
    required this.contactEmailText,
    required this.contactPhoneText,
    required this.contactMailText,
    required this.contactSmsText,
    required this.submitButtonText,
    required this.successMessage,
    required this.errorMessages,
    required this.donationAmounts,
  });

  factory DonationWidgetContent.fromJson(Map<String, dynamic> json) {
    return DonationWidgetContent(
      amountSelectionPrompt: json['amountSelectionPrompt'],
      customAmountLabel: json['customAmountLabel'],
      continueButtonText: json['continueButtonText'],
      firstNameValidation: json['firstNameValidation'],
      lastNameValidation: json['lastNameValidation'],
      addressValidation: json['addressValidation'],
      addressLine2Label: json['addressLine2Label'],
      cityLabel: json['cityLabel'],
      stateLabel: json['stateLabel'],
      zipCodeLabel: json['zipCodeLabel'],
      employerLabel: json['employerLabel'],
      occupationLabel: json['occupationLabel'],
      proceedToPaymentButtonText: json['proceedToPaymentButtonText'],
      coverFeesText: json['coverFeesText'],
      recurringDonationText: json['recurringDonationText'],
      emailLabel: json['emailLabel'],
      phoneLabel: json['phoneLabel'],
      emailValidationEmpty: json['emailValidationEmpty'],
      emailValidationInvalid: json['emailValidationInvalid'],
      contactEmailText: json['contactEmailText'],
      contactPhoneText: json['contactPhoneText'],
      contactMailText: json['contactMailText'],
      contactSmsText: json['contactSmsText'],
      submitButtonText: json['submitButtonText'],
      successMessage: json['successMessage'],
      errorMessages: ErrorMessagesContent.fromJson(json['errorMessages']),
      donationAmounts: (json['donationAmounts'] as List).map((e) => e as int).toList(),
    );
  }
}
