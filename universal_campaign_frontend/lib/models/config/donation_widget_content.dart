class DonationWidgetContent {
  final List<int> amounts;
  final String customAmountLabel;
  final String continueButtonText;
  final String selectAmountValidation;
  final String firstNameLabel;
  final String lastNameLabel;
  final String addressLine1Label;
  final String addressLine2Label;
  final String cityLabel;
  final String stateLabel;
  final String zipCodeLabel;
  final String employerLabel;
  final String occupationLabel;
  final String firstNameValidation;
  final String lastNameValidation;
  final String addressValidation;
  final String cityValidation;
  final String stateValidation;
  final String zipCodeValidation;
  final String employerValidation;
  final String occupationValidation;
  final String proceedToPaymentButtonText;
  final String coverFeesText;
  final String recurringDonationText;
  final String emailLabel;
  final String phoneNumberLabel;
  final String emailValidation;
  final String invalidEmailValidation;
  final String contactEmailText;
  final String contactPhoneText;
  final String contactMailText;
  final String contactSmsText;
  final String submitButtonText;

  DonationWidgetContent({
    required this.amounts,
    required this.customAmountLabel,
    required this.continueButtonText,
    required this.selectAmountValidation,
    required this.firstNameLabel,
    required this.lastNameLabel,
    required this.addressLine1Label,
    required this.addressLine2Label,
    required this.cityLabel,
    required this.stateLabel,
    required this.zipCodeLabel,
    required this.employerLabel,
    required this.occupationLabel,
    required this.firstNameValidation,
    required this.lastNameValidation,
    required this.addressValidation,
    required this.cityValidation,
    required this.stateValidation,
    required this.zipCodeValidation,
    required this.employerValidation,
    required this.occupationValidation,
    required this.proceedToPaymentButtonText,
    required this.coverFeesText,
    required this.recurringDonationText,
    required this.emailLabel,
    required this.phoneNumberLabel,
    required this.emailValidation,
    required this.invalidEmailValidation,
    required this.contactEmailText,
    required this.contactPhoneText,
    required this.contactMailText,
    required this.contactSmsText,
    required this.submitButtonText,
  });

  factory DonationWidgetContent.fromJson(Map<String, dynamic> json) {
    return DonationWidgetContent(
      amounts: List<int>.from(json['amounts'] ?? [25, 50, 100, 250, 500, 1000]),
      customAmountLabel: json['customAmountLabel'] ?? 'Custom Amount',
      continueButtonText: json['continueButtonText'] ?? 'Continue',
      selectAmountValidation: json['selectAmountValidation'] ?? 'Please select or enter an amount',
      firstNameLabel: json['firstNameLabel'] ?? 'First Name',
      lastNameLabel: json['lastNameLabel'] ?? 'Last Name',
      addressLine1Label: json['addressLine1Label'] ?? 'Address Line 1',
      addressLine2Label: json['addressLine2Label'] ?? 'Address Line 2 (Optional)',
      cityLabel: json['cityLabel'] ?? 'City',
      stateLabel: json['stateLabel'] ?? 'State',
      zipCodeLabel: json['zipCodeLabel'] ?? 'Zip Code',
      employerLabel: json['employerLabel'] ?? 'Employer',
      occupationLabel: json['occupationLabel'] ?? 'Occupation',
      firstNameValidation: json['firstNameValidation'] ?? 'Please enter your first name',
      lastNameValidation: json['lastNameValidation'] ?? 'Please enter your last name',
      addressValidation: json['addressValidation'] ?? 'Please enter your address',
      cityValidation: json['cityValidation'] ?? 'Please enter your city',
      stateValidation: json['stateValidation'] ?? 'Please enter your state',
      zipCodeValidation: json['zipCodeValidation'] ?? 'Please enter your zip code',
      employerValidation: json['employerValidation'] ?? 'Please enter your employer',
      occupationValidation: json['occupationValidation'] ?? 'Please enter your occupation',
      proceedToPaymentButtonText: json['proceedToPaymentButtonText'] ?? 'Proceed to Payment',
      coverFeesText: json['coverFeesText'] ?? 'Cover transaction fees',
      recurringDonationText: json['recurringDonationText'] ?? 'Make this a recurring monthly donation',
      emailLabel: json['emailLabel'] ?? 'Email',
      phoneNumberLabel: json['phoneNumberLabel'] ?? 'Phone Number',
      emailValidation: json['emailValidation'] ?? 'Please enter your email',
      invalidEmailValidation: json['invalidEmailValidation'] ?? 'Please enter a valid email address',
      contactEmailText: json['contactEmailText'] ?? 'Contact me via Email',
      contactPhoneText: json['contactPhoneText'] ?? 'Contact me via Phone Call',
      contactMailText: json['contactMailText'] ?? 'Contact me via Mail',
      contactSmsText: json['contactSmsText'] ?? 'Contact me via SMS',
      submitButtonText: json['submitButtonText'] ?? 'Submit',
    );
  }
}
