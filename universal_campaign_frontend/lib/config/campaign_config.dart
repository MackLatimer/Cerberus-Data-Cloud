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
    );
  }
}

class HomePageContent {
  final String heroTitle;
  final String callToActionText;
  final String heroImagePath;

  HomePageContent({
    required this.heroTitle,
    required this.callToActionText,
    required this.heroImagePath,
  });

  factory HomePageContent.fromJson(Map<String, dynamic> json) {
    return HomePageContent(
      heroTitle: json['heroTitle'],
      callToActionText: json['callToActionText'],
      heroImagePath: json['heroImagePath'],
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
  final List<NavItem> navItems;

  CommonAppBarContent({
    required this.logoPath,
    required this.navItems,
  });

  factory CommonAppBarContent.fromJson(Map<String, dynamic> json) {
    return CommonAppBarContent(
      logoPath: json['logoPath'],
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
  final String title;
  final List<IssueSectionContent> issueSections;

  IssuesPageContent({
    required this.appBarTitle,
    required this.title,
    required this.issueSections,
  });

  factory IssuesPageContent.fromJson(Map<String, dynamic> json) {
    return IssuesPageContent(
      appBarTitle: json['appBarTitle'],
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

class CommonAppBarAssets {
  final double logoWidth;
  final double logoHeight;

  CommonAppBarAssets({
    required this.logoWidth,
    required this.logoHeight,
  });

  factory CommonAppBarAssets.fromJson(Map<String, dynamic> json) {
    return CommonAppBarAssets(
      logoWidth: json['logoWidth'],
      logoHeight: json['logoHeight'],
    );
  }
}

class CommonAppBarAssets {
  final double logoWidth;
  final double logoHeight;

  CommonAppBarAssets({
    required this.logoWidth,
    required this.logoHeight,
  });

  factory CommonAppBarAssets.fromJson(Map<String, dynamic> json) {
    return CommonAppBarAssets(
      logoWidth: json['logoWidth'],
      logoHeight: json['logoHeight'],
    );
  }
}

class IssuesPageAssets {
  final String heroImagePath;

  IssuesPageAssets({
    required this.heroImagePath,
  });

  factory IssuesPageAssets.fromJson(Map<String, dynamic> json) {
    return IssuesPageAssets(
      heroImagePath: json['heroImagePath'],
    );
  }
}

class DonatePageContent {
  final String appBarTitle;
  final String title;
  final String mailDonationText;
  final String thankYouText;

  DonatePageContent({
    required this.appBarTitle,
    required this.title,
    required this.mailDonationText,
    required this.thankYouText,
  });

  factory DonatePageContent.fromJson(Map<String, dynamic> json) {
    return DonatePageContent(
      appBarTitle: json['appBarTitle'],
      title: json['title'],
      mailDonationText: json['mailDonationText'],
      thankYouText: json['thankYouText'],
    );
  }
}

class ComingSoonPageContent {
  final String title;
  final String subtitle;

  ComingSoonPageContent({
    required this.title,
    required this.subtitle,
  });

  factory ComingSoonPageContent.fromJson(Map<String, dynamic> json) {
    return ComingSoonPageContent(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }
}

class AboutPageContent {
  final String appBarTitle;
  final String heroImagePath;
  final String title;
  final String bioText;
  final String bioImage1Path;
  final String bioImage2Path;
  final String bioImage3Path;

  AboutPageContent({
    required this.appBarTitle,
    required this.heroImagePath,
    required this.title,
    required this.bioText,
    required this.bioImage1Path,
    required this.bioImage2Path,
    required this.bioImage3Path,
  });

  factory AboutPageContent.fromJson(Map<String, dynamic> json) {
    return AboutPageContent(
      appBarTitle: json['appBarTitle'],
      heroImagePath: json['heroImagePath'],
      title: json['title'],
      bioText: json['bioText'],
      bioImage1Path: json['bioImage1Path'],
      bioImage2Path: json['bioImage2Path'],
      bioImage3Path: json['bioImage3Path'],
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
