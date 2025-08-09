import 'package:flutter/material.dart';

class CampaignConfig {
  final String stripePublicKey;
  final String campaignId;
  final String campaignName;
  final String domain;

  final Color primaryColor;
  final Color secondaryColor;

  final String fontHeader;
  final String fontBody;

  final HomePageText homePageText;
  final IssuesPageText issuesPageText;
  final EndorsementsPageText endorsementsPageText;
  final AboutPageText aboutPageText;

  final int numberOfIssues;
  final int numberOfDistinguishedEndorsements;

  CampaignConfig({
    required this.stripePublicKey,
    required this.campaignId,
    required this.campaignName,
    required this.domain,
    required this.primaryColor,
    required this.secondaryColor,
    required this.fontHeader,
    required this.fontBody,
    required this.homePageText,
    required this.issuesPageText,
    required this.endorsementsPageText,
    required this.aboutPageText,
    required this.numberOfIssues,
    required this.numberOfDistinguishedEndorsements,
  });
}

class HomePageText {
  final String aboutPreview;
  final String issuesPreview;
  final String endorsementsPreview;
  final String donatePreview;

  HomePageText({
    required this.aboutPreview,
    required this.issuesPreview,
    required this.endorsementsPreview,
    required this.donatePreview,
  });
}

class IssuesPageText {
  final String heroTitle;
  final List<Issue> issues;

  IssuesPageText({
    required this.heroTitle,
    required this.issues,
  });
}

class Issue {
  final String title;
  final String content;
  final String imagePath;

  Issue({
    required this.title,
    required this.content,
    required this.imagePath,
  });
}

class EndorsementsPageText {
  final String heroTitle;
  final List<Endorsement> distinguishedEndorsements;
  final List<Endorsement> endorsements;

  EndorsementsPageText({
    required this.heroTitle,
    required this.distinguishedEndorsements,
    required this.endorsements,
  });
}

class Endorsement {
  final String name;
  final String title;
  final String imagePath;

  Endorsement({
    required this.name,
    required this.title,
    required this.imagePath,
  });
}

class AboutPageText {
  final String heroTitle;
  final String bio1;
  final String bio2;
  final String bio3;

  AboutPageText({
    required this.heroTitle,
    required this.bio1,
    required this.bio2,
    required this.bio3,
  });
}
