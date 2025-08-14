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
