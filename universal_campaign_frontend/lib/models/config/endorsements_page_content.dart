import 'package:universal_campaign_frontend/models/config/endorsement.dart';

class EndorsementsPageContent {
  final String appBarTitle;
  final String heroImagePath;
  final String title;
  final List<Endorsement> endorsements;
  final String communityTitle;
  final List<String> communityEndorsements;
  final String endorsementCallToAction;
  final String endorsementCallToActionText;

  EndorsementsPageContent({
    required this.appBarTitle,
    required this.heroImagePath,
    required this.title,
    required this.endorsements,
    required this.communityTitle,
    required this.communityEndorsements,
    required this.endorsementCallToAction,
    required this.endorsementCallToActionText,
  });

  factory EndorsementsPageContent.fromJson(Map<String, dynamic> json) {
    return EndorsementsPageContent(
      appBarTitle: json['appBarTitle'] ?? '',
      heroImagePath: json['heroImagePath'] ?? '',
      title: json['title'] ?? '',
      endorsements: (json['endorsements'] as List? ?? [])
          .map((i) => Endorsement.fromJson(i))
          .toList(),
      communityTitle: json['communityTitle'] ?? '',
      communityEndorsements: (json['communityEndorsements'] as List? ?? [])
          .map((i) => i.toString())
          .toList(),
      endorsementCallToAction: json['endorsementCallToAction'] ?? '',
      endorsementCallToActionText: json['endorsementCallToActionText'] ?? '',
    );
  }
}
