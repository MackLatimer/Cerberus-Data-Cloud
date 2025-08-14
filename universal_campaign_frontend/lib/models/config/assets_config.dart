import 'package:universal_campaign_frontend/models/config/home_page_assets.dart';
import 'package:universal_campaign_frontend/models/config/about_page_assets.dart';
import 'package:universal_campaign_frontend/models/config/donate_page_assets.dart';
import 'package:universal_campaign_frontend/models/config/endorsements_page_assets.dart';
import 'package:universal_campaign_frontend/models/config/issues_page_assets.dart';
import 'package:universal_campaign_frontend/models/config/common_app_bar_assets.dart';

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
