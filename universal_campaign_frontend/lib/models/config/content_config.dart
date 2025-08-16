import 'package:universal_campaign_frontend/models/config/home_page_content.dart';
import 'package:universal_campaign_frontend/models/config/about_page_content.dart';
import 'package:universal_campaign_frontend/models/config/coming_soon_page_content.dart';
import 'package:universal_campaign_frontend/models/config/donate_page_content.dart';
import 'package:universal_campaign_frontend/models/config/endorsements_page_content.dart';
import 'package:universal_campaign_frontend/models/config/issues_page_content.dart';
import 'package:universal_campaign_frontend/models/config/privacy_policy_page_content.dart';
import 'package:universal_campaign_frontend/models/config/common_app_bar_content.dart';
import 'package:universal_campaign_frontend/models/config/donate_section_content.dart';
import 'package:universal_campaign_frontend/models/config/footer_content.dart';
import 'package:universal_campaign_frontend/models/config/error_page_content.dart';
import 'package:universal_campaign_frontend/models/config/widgets_content.dart';
import 'package:universal_campaign_frontend/models/config/donation_widget_content.dart';
import 'package:universal_campaign_frontend/models/config/signup_form_content.dart';

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
  final DonationWidgetContent donationWidget;
  final SignupFormContent signupForm;

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
    required this.donationWidget,
    required this.signupForm,
  });

  factory ContentConfig.fromJson(Map<String, dynamic> json) {
    return ContentConfig(
      siteTitle: json['siteTitle'] ?? '',
      faviconImagePath: json['faviconImagePath'] ?? '',
      homePage: HomePageContent.fromJson(json['homePage'] ?? {}),
      aboutPage: AboutPageContent.fromJson(json['aboutPage'] ?? {}),
      comingSoonPage: ComingSoonPageContent.fromJson(json['comingSoonPage'] ?? {}),
      donatePage: DonatePageContent.fromJson(json['donatePage'] ?? {}),
      endorsementsPage: EndorsementsPageContent.fromJson(json['endorsementsPage'] ?? {}),
      issuesPage: IssuesPageContent.fromJson(json['issuesPage'] ?? {}),
      privacyPolicyPage: PrivacyPolicyPageContent.fromJson(json['privacyPolicyPage'] ?? {}),
      commonAppBar: CommonAppBarContent.fromJson(json['commonAppBar'] ?? {}),
      donateSection: DonateSectionContent.fromJson(json['donateSection'] ?? {}),
      footer: FooterContent.fromJson(json['footer'] ?? {}),
      errorPage: ErrorPageContent.fromJson(json['errorPage'] ?? {}),
      widgets: WidgetsContent.fromJson(json['widgets'] ?? {}),
      donationWidget: DonationWidgetContent.fromJson(json['donationWidget'] ?? {}),
      signupForm: SignupFormContent.fromJson(json['signupForm'] ?? {}),
    );
  }
}