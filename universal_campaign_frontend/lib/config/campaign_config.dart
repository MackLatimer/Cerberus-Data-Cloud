import 'package:flutter/material.dart';

class CampaignConfig {
  final String campaignId;
  final bool defaultCampaign;
  final String stripeSecretKeySecretManagerName;
  final String stripeWebhookKeySecretManagerName;
  final String apiBaseUrl;
  final ThemeConfig theme;
  final ContentConfig content;
  final AssetsConfig assets;
  final String stripePublicKey;

  CampaignConfig({
    required this.campaignId,
    required this.defaultCampaign,
    required this.stripeSecretKeySecretManagerName,
    required this.stripeWebhookKeySecretManagerName,
    required this.apiBaseUrl,
    required this.theme,
    required this.content,
    required this.assets,
    required this.stripePublicKey,
  });

  factory CampaignConfig.fromJson(Map<String, dynamic> json) {
    return CampaignConfig(
      campaignId: json['campaignId'],
      defaultCampaign: json['defaultCampaign'] ?? false,
      stripeSecretKeySecretManagerName: json['stripeSecretKeySecretManagerName'],
      stripeWebhookKeySecretManagerName: json['stripeWebhookKeySecretManagerName'],
      apiBaseUrl: json['apiBaseUrl'],
      theme: ThemeConfig.fromJson(json['theme']),
      content: ContentConfig.fromJson(json['content']),
      assets: AssetsConfig.fromJson(json['assets']),
      stripePublicKey: json['stripePublicKey'],
    );
  }
}

class ThemeConfig {
  final String primaryColor;
  final String secondaryColor;
  final String backgroundColor;
  final String textColor;
  final String fontFamily;
  final String secondaryFontFamily;

  ThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.fontFamily,
    required this.secondaryFontFamily,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      primaryColor: json['primaryColor'],
      secondaryColor: json['secondaryColor'],
      backgroundColor: json['backgroundColor'],
      textColor: json['textColor'],
      fontFamily: json['fontFamily'],
      secondaryFontFamily: json['secondaryFontFamily'],
    );
  }
}

class ContentConfig {
  final String siteTitle;
  final String faviconImagePath;
  final HomePageContent homePage;
  final AboutPageContent aboutPage;
  final ComingSoonPageContent comingSoonPage;
  final DonatePageContent donatePage;
  final EndorsementsPageContent endorsementsPage;
  final IssuesPageContent issuesPage;
  final PrivacyPolicyPageContent privacyPolicyPage;
  final CommonAppBarContent commonAppBar;
  final DonateSectionContent donateSection;
  final FooterContent footer;
  final ErrorPageContent errorPage;
  final WidgetsContent widgets;
  final DonationWidgetContent donationWidget; // Added

  ContentConfig({
    required this.siteTitle,
    required this.faviconImagePath,
    required this.homePage,
    required this.aboutPage,
    required this.comingSoonPage,
    required this.donatePage,
    required this.endorsementsPage,
    required this.issuesPage,
    required this.privacyPolicyPage,
    required this.commonAppBar,
    required this.donateSection,
    required this.footer,
    required this.errorPage,
    required this.widgets,
    required this.donationWidget, // Added
  });

  factory ContentConfig.fromJson(Map<String, dynamic> json) {
    return ContentConfig(
      siteTitle: json['siteTitle'],
      faviconImagePath: json['faviconImagePath'],
      homePage: HomePageContent.fromJson(json['homePage']),
      aboutPage: AboutPageContent.fromJson(json['aboutPage']),
      comingSoonPage: ComingSoonPageContent.fromJson(json['comingSoonPage']),
      donatePage: DonatePageContent.fromJson(json['donatePage']),
      endorsementsPage: EndorsementsPageContent.fromJson(json['endorsementsPage']),
      issuesPage: IssuesPageContent.fromJson(json['issuesPage']),
      privacyPolicyPage: PrivacyPolicyPageContent.fromJson(json['privacyPolicyPage']),
      commonAppBar: CommonAppBarContent.fromJson(json['commonAppBar']),
      donateSection: DonateSectionContent.fromJson(json['donateSection']),
      footer: FooterContent.fromJson(json['footer']),
      errorPage: ErrorPageContent.fromJson(json['errorPage']),
      widgets: WidgetsContent.fromJson(json['widgets']),
      donationWidget: DonationWidgetContent.fromJson(json['donationWidget']), // Added
    );
  }
}

class HomePageContent {
  final String heroTitle;
  final String callToActionText;
  final String heroImagePath;
  final String homeTitleMessage;
  final String issuesImage;
  final String issuesMessage;
  final String issuesButton;
  final String aboutMeImage;
  final String aboutMeMessage;
  final String aboutMeButton;
  final String endorsementsImage;
  final String endorsementsMessage;
  final String endorsementsButton;
  final String donateImage;
  final String donateMessage;
  final String donateButton;

  HomePageContent({
    required this.heroTitle,
    required this.callToActionText,
    required this.heroImagePath,
    required this.homeTitleMessage,
    required this.issuesImage,
    required this.issuesMessage,
    required this.issuesButton,
    required this.aboutMeImage,
    required this.aboutMeMessage,
    required this.aboutMeButton,
    required this.endorsementsImage,
    required this.endorsementsMessage,
    required this.endorsementsButton,
    required this.donateImage,
    required this.donateMessage,
    required this.donateButton,
  });

  factory HomePageContent.fromJson(Map<String, dynamic> json) {
    return HomePageContent(
      heroTitle: json['heroTitle'],
      callToActionText: json['callToActionText'],
      heroImagePath: json['heroImagePath'],
      homeTitleMessage: json['homeTitleMessage'],
      issuesImage: json['issuesImage'],
      issuesMessage: json['issuesMessage'],
      issuesButton: json['issuesButton'],
      aboutMeImage: json['aboutMeImage'],
      aboutMeMessage: json['aboutMeMessage'],
      aboutMeButton: json['aboutMeButton'],
      endorsementsImage: json['endorsementsImage'],
      endorsementsMessage: json['endorsementsMessage'],
      endorsementsButton: json['endorsementsButton'],
      donateImage: json['donateImage'],
      donateMessage: json['donateMessage'],
      donateButton: json['donateButton'],
    );
  }
}

class WidgetsContent {
  final SignupFormContent signupForm;

  WidgetsContent({
    required this.signupForm,
  });

  factory WidgetsContent.fromJson(Map<String, dynamic> json) {
    return WidgetsContent(
      signupForm: SignupFormContent.fromJson(json['signupForm']),
    );
  }
}

class ErrorPageContent {
  final String appBarTitle;
  final String errorMessagePrefix;

  ErrorPageContent({
    required this.appBarTitle,
    required this.errorMessagePrefix,
  });

  factory ErrorPageContent.fromJson(Map<String, dynamic> json) {
    return ErrorPageContent(
      appBarTitle: json['appBarTitle'],
      errorMessagePrefix: json['errorMessagePrefix'],
    );
  }
}

class FooterContent {
  final String paidForText;

  FooterContent({
    required this.paidForText,
  });

  factory FooterContent.fromJson(Map<String, dynamic> json) {
    return FooterContent(
      paidForText: json['paidForText'],
    );
  }
}

class DonateSectionContent {
  final String title;
  final String buttonText;

  DonateSectionContent({
    required this.title,
    required this.buttonText,
  });

  factory DonateSectionContent.fromJson(Map<String, dynamic> json) {
    return DonateSectionContent(
      title: json['title'],
      buttonText: json['buttonText'],
    );
  }
}

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
      logoPath: json['logoPath'],
      logoWidth: (json['logoWidth'] as num).toDouble(), // Added
      logoHeight: (json['logoHeight'] as num).toDouble(), // Added
      navItems: (json['navItems'] as List)
          .map((i) => NavItem.fromJson(i))
          .toList(),
    );
  }
}

class NavItem {
  final String label;
  final String path;

  NavItem({
    required this.label,
    required this.path,
  });

  factory NavItem.fromJson(Map<String, dynamic> json) {
    return NavItem(
      label: json['label'],
      path: json['path'],
    );
  }
}

class PrivacyPolicyPageContent {
  final String appBarTitle;
  final String title;
  final String content;

  PrivacyPolicyPageContent({
    required this.appBarTitle,
    required this.title,
    required this.content,
  });

  factory PrivacyPolicyPageContent.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyPageContent(
      appBarTitle: json['appBarTitle'],
      title: json['title'],
      content: json['content'],
    );
  }
}

class IssuesPageContent {
  final String appBarTitle;
  final String heroImagePath; // Added
  final String title;
  final List<IssueSectionContent> issueSections;

  IssuesPageContent({
    required this.appBarTitle,
    required this.heroImagePath, // Added
    required this.title,
    required this.issueSections,
  });

  factory IssuesPageContent.fromJson(Map<String, dynamic> json) {
    return IssuesPageContent(
      appBarTitle: json['appBarTitle'],
      heroImagePath: json['heroImagePath'], // Added
      title: json['title'],
      issueSections: (json['issueSections'] as List)
          .map((i) => IssueSectionContent.fromJson(i))
          .toList(),
    );
  }
}

class IssueSectionContent {
  final String title;
  final String description;
  final String? backgroundColor;
  final String? textColor;
  final String imagePath;

  IssueSectionContent({
    required this.title,
    required this.description,
    this.backgroundColor,
    this.textColor,
    required this.imagePath,
  });

  factory IssueSectionContent.fromJson(Map<String, dynamic> json) {
    return IssueSectionContent(
      title: json['title'],
      description: json['description'],
      backgroundColor: json['backgroundColor'],
      textColor: json['textColor'],
      imagePath: json['imagePath'],
    );
  }
}

class AssetsConfig {
  final String faviconImagePath;
  final HomePageAssets homePage;
  final AboutPageAssets aboutPage;
  final DonatePageAssets donatePage;
  final EndorsementsPageAssets endorsementsPage;
  final IssuesPageAssets issuesPage;
  final CommonAppBarAssets commonAppBar;

  AssetsConfig({
    required this.faviconImagePath,
    required this.homePage,
    required this.aboutPage,
    required this.donatePage,
    required this.endorsementsPage,
    required this.issuesPage,
    required this.commonAppBar,
  });

  factory AssetsConfig.fromJson(Map<String, dynamic> json) {
    return AssetsConfig(
      faviconImagePath: json['faviconImagePath'],
      homePage: HomePageAssets.fromJson(json['homePage']),
      aboutPage: AboutPageAssets.fromJson(json['aboutPage']),
      donatePage: DonatePageAssets.fromJson(json['donatePage']),
      endorsementsPage: EndorsementsPageAssets.fromJson(json['endorsementsPage']),
      issuesPage: IssuesPageAssets.fromJson(json['issuesPage']),
      commonAppBar: CommonAppBarAssets.fromJson(json['commonAppBar']),
    );
  }
}

class HomePageAssets {
  final String logoPath;
  final String heroImagePath;

  HomePageAssets({
    required this.logoPath,
    required this.heroImagePath,
  });

  factory HomePageAssets.fromJson(Map<String, dynamic> json) {
    return HomePageAssets(
      logoPath: json['logoPath'],
      heroImagePath: json['heroImagePath'],
    );
  }
}

class DonatePageAssets {
  final String heroImagePath;

  DonatePageAssets({
    required this.heroImagePath,
  });

  factory DonatePageAssets.fromJson(Map<String, dynamic> json) {
    return DonatePageAssets(
      heroImagePath: json['heroImagePath'],
    );
  }
}

class AboutPageAssets {
  final String heroImagePath;
  final String bioImage1Path;
  final String bioImage2Path;
  final String bioImage3Path;

  AboutPageAssets({
    required this.heroImagePath,
    required this.bioImage1Path,
    required this.bioImage2Path,
    required this.bioImage3Path,
  });

  factory AboutPageAssets.fromJson(Map<String, dynamic> json) {
    return AboutPageAssets(
      heroImagePath: json['heroImagePath'],
      bioImage1Path: json['bioImage1Path'],
      bioImage2Path: json['bioImage2Path'],
      bioImage3Path: json['bioImage3Path'],
    );
  }
}

// New classes added below

class EndorsementsPageContent {
  final String appBarTitle;
  final String heroImagePath;
  final String title;
  final List<Endorsement> endorsements;
  final List<String> communityEndorsements;
  final String endorsementTitle1;
  final String endorsementTitle2;
  final String endorsementBodyParagraph;

  EndorsementsPageContent({
    required this.appBarTitle,
    required this.heroImagePath,
    required this.title,
    required this.endorsements,
    required this.communityEndorsements,
    required this.endorsementTitle1,
    required this.endorsementTitle2,
    required this.endorsementBodyParagraph,
  });

  factory EndorsementsPageContent.fromJson(Map<String, dynamic> json) {
    return EndorsementsPageContent(
      appBarTitle: json['appBarTitle'],
      heroImagePath: json['heroImagePath'],
      title: json['title'],
      endorsements: (json['endorsements'] as List)
          .map((i) => Endorsement.fromJson(i))
          .toList(),
      communityEndorsements: (json['communityEndorsements'] as List)
          .map((i) => i.toString())
          .toList(),
      endorsementTitle1: json['endorsementTitle1'],
      endorsementTitle2: json['endorsementTitle2'],
      endorsementBodyParagraph: json['endorsementBodyParagraph'],
    );
  }
}

class Endorsement {
  final String name;
  final String quote;
  final String imagePath;
  final bool imageLeft;
  final String backgroundColor;
  final String textColor;

  Endorsement({
    required this.name,
    required this.quote,
    required this.imagePath,
    required this.imageLeft,
    required this.backgroundColor,
    required this.textColor,
  });

  factory Endorsement.fromJson(Map<String, dynamic> json) {
    return Endorsement(
      name: json['name'],
      quote: json['quote'],
      imagePath: json['imagePath'],
      imageLeft: json['imageLeft'],
      backgroundColor: json['backgroundColor'],
      textColor: json['textColor'],
    );
  }
}

class DonatePageContent {
  final String appBarTitle;
  final String heroImagePath; // Added
  final String title;
  final String mailDonationText;
  final String thankYouText;

  DonatePageContent({
    required this.appBarTitle,
    required this.heroImagePath, // Added
    required this.title,
    required this.mailDonationText,
    required this.thankYouText,
  });

  factory DonatePageContent.fromJson(Map<String, dynamic> json) {
    return DonatePageContent(
      appBarTitle: json['appBarTitle'],
      heroImagePath: json['heroImagePath'], // Added
      title: json['title'],
      mailDonationText: json['mailDonationText'],
      thankYouText: json['thankYouText'],
    );
  }
}

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
      title: json['title'],
      endorseText: json['endorseText'],
      getInvolvedText: json['getInvolvedText'],
      automatedMessagingText: json['automatedMessagingText'],
      emailOptInText: json['emailOptInText'],
      legalText: json['legalText'],
      submitButtonText: json['submitButtonText'],
      privacyPolicyText: json['privacyPolicyText'],
    );
  }
}