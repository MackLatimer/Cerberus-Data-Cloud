import 'package:universal_campaign_frontend/models/config/endorsement.dart';

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
