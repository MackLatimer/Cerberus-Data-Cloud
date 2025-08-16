import 'package:universal_campaign_frontend/models/config/issue_section_content.dart';

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
      appBarTitle: json['appBarTitle'] ?? '',
      heroImagePath: json['heroImagePath'] ?? '', // Added
      title: json['title'] ?? '',
      issueSections: (json['issueSections'] as List? ?? [])
          .map((i) => IssueSectionContent.fromJson(i))
          .toList(),
    );
  }
}
