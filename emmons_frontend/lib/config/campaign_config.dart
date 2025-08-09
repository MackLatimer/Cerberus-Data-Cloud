import 'package:emmons_frontend/models/endorsement.dart';
import 'package:emmons_frontend/models/issue.dart';
import 'package:flutter/material.dart';

class HomePageSectionConfig {
  final String title;
  final String summary;
  final String imagePath;
  final String routePath;
  final Color imageBackgroundColor;
  final bool imageLeft;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? buttonColor;
  final Color? buttonTextColor;

  const HomePageSectionConfig({
    required this.title,
    required this.summary,
    required this.imagePath,
    required this.routePath,
    required this.imageBackgroundColor,
    required this.imageLeft,
    this.backgroundColor,
    this.textColor,
    this.buttonColor,
    this.buttonTextColor,
  });
}

class CampaignConfig {
  final String campaignId;
  final String domain;
  final String siteTitle;
  final ThemeData theme;
  final StripeConfig stripe;
  final ContentConfig content;
  final List<Issue> issues;
  final List<Endorsement> endorsements;
  final String apiBaseUrl;
  final List<HomePageSectionConfig> homePageSections;
  final List<String> communityEndorsers;

  const CampaignConfig({
    required this.campaignId,
    required this.domain,
    required this.siteTitle,
    required this.theme,
    required this.stripe,
    required this.content,
    required this.issues,
    required this.endorsements,
    required this.apiBaseUrl,
    required this.homePageSections,
    required this.communityEndorsers,
  });
}

class StripeConfig {
  final String publicKey;
  final String connectedAccountId;

  const StripeConfig({required this.publicKey, required this.connectedAccountId});
}

class ContentConfig {
  final String heroTitle;
  final String heroSubtitle;
  final String callToActionLabel;
  final String welcomeTitle;
  final String welcomeSubtitle;
  final String issuesPageHeroImagePath;
  final String issuesPageTitle;
  final String aboutPageTitle;
  final String aboutPageSubtitle;
  final String aboutPageHeroImagePath;
  final String aboutPageBio;
  final String aboutPageBioImage1Path;
  final String aboutPageBioImage2Path;
  final String aboutPageBioImage3Path;
  final String endorsementsPageTitle;
  final String endorsementsPageSubtitle;
  final String endorsementsPageHeroImagePath;
  final String communityEndorsersTitle;
  final String addYourVoiceTitle;
  final String addYourVoiceSubtitle;
  final String donatePageTitle;
  final String donatePageSubtitle;
  final String donatePageHeroImagePath;
  final String donatePageMailInstructions;
  final String donatePageThankYouText;
  final String footerText;
  final String signupFormTitle;
  final String signupFormEndorseCheckboxLabel;
  final String signupFormInvolvedCheckboxLabel;
  final String signupFormMessagingCheckboxLabel;
  final String signupFormEmailCheckboxLabel;
  final String signupFormSmsDisclaimer;
  final String signupFormSubmitButtonLabel;
  final String donateSectionTitle;
  final String donationWidgetContinueButtonLabel;
  final String donationWidgetProceedButtonLabel;
  final String donationWidgetCoverFeesCheckboxLabel;
  final String donationWidgetRecurringCheckboxLabel;
  final String donationWidgetContactEmailCheckboxLabel;
  final String donationWidgetContactPhoneCheckboxLabel;
  final String donationWidgetContactMailCheckboxLabel;
  final String donationWidgetContactSmsCheckboxLabel;
  final String donationWidgetSubmitButtonLabel;


  const ContentConfig({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.callToActionLabel,
    required this.welcomeTitle,
    required this.welcomeSubtitle,
    required this.issuesPageHeroImagePath,
    required this.issuesPageTitle,
    required this.aboutPageTitle,
    required this.aboutPageSubtitle,
    required this.aboutPageHeroImagePath,
    required this.aboutPageBio,
    required this.aboutPageBioImage1Path,
    required this.aboutPageBioImage2Path,
    required this.aboutPageBioImage3Path,
    required this.endorsementsPageTitle,
    required this.endorsementsPageSubtitle,
    required this.endorsementsPageHeroImagePath,
    required this.communityEndorsersTitle,
    required this.addYourVoiceTitle,
    required this.addYourVoiceSubtitle,
    required this.donatePageTitle,
    required this.donatePageSubtitle,
    required this.donatePageHeroImagePath,
    required this.donatePageMailInstructions,
    required this.donatePageThankYouText,
    required this.footerText,
    required this.signupFormTitle,
    required this.signupFormEndorseCheckboxLabel,
    required this.signupFormInvolvedCheckboxLabel,
    required this.signupFormMessagingCheckboxLabel,
    required this.signupFormEmailCheckboxLabel,
    required this.signupFormSmsDisclaimer,
    required this.signupFormSubmitButtonLabel,
    required this.donateSectionTitle,
    required this.donationWidgetContinueButtonLabel,
    required this.donationWidgetProceedButtonLabel,
    required this.donationWidgetCoverFeesCheckboxLabel,
    required this.donationWidgetRecurringCheckboxLabel,
    required this.donationWidgetContactEmailCheckboxLabel,
    required this.donationWidgetContactPhoneCheckboxLabel,
    required this.donationWidgetContactMailCheckboxLabel,
    required this.donationWidgetContactSmsCheckboxLabel,
    required this.donationWidgetSubmitButtonLabel,
  });
}
