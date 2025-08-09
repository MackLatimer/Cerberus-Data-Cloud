import 'package:flutter/material.dart';
import 'package:emmons_frontend/config/campaign_config.dart';
import 'package:emmons_frontend/models/issue.dart';
import 'package:emmons_frontend/models/endorsement.dart';

final emmonsCampaign = CampaignConfig(
  campaignId: "emmons-2024",
  domain: "emmonsforcongress.com",
  siteTitle: "Emmons for Congress | A New Voice",
  apiBaseUrl: "https://api.emmonsforcongress.com/api/v1",
  theme: ThemeData(
    primaryColor: const Color(0xffa01124),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xffa01124),
      secondary: const Color(0xff002663),
    ),
    fontFamily: "Roboto",
  ),
  stripe: const StripeConfig(
    publicKey: "pk_test_51Rnnfv4brLkKMnfT9dQISZb1hLmvQMVq3nr8Ymb67lqFQ4JwJkTrc92dRUXKYvYs3tSMeYZkTgIkKJxLsOmjqTN800f2UFiJiT",
    connectedAccountId: "acct_emmons456"
  ),
  content: const ContentConfig(
    heroTitle: "Fighting for Our Future",
    heroSubtitle: "Join the movement for change.",
    callToActionLabel: "Donate Now",
    welcomeTitle: "Welcome to the Campaign!",
    welcomeSubtitle: "Join us in making a difference for Bell County Precinct 4. Curtis Emmons is dedicated to serving our community with integrity, transparency, and a commitment to progress.",
    issuesPageHeroImagePath: "assets/images/Emmons_Issues_Hero.png",
    issuesPageTitle: "Key Issues",
    aboutPageTitle: "About Curtis Emmons",
    aboutPageSubtitle: "About Me",
    aboutPageHeroImagePath: "assets/images/Emmons_About_Hero.png",
    aboutPageBio: "Curtis Emmons is a dedicated public servant with a passion for community development and effective governance. With a background in business and a commitment to fiscal responsibility, Curtis brings a wealth of experience to the table. He is a strong advocate for transparency and accountability in government, and he is committed to working collaboratively to find solutions to the challenges facing our county.\n\nThroughout his career, Curtis has been actively involved in numerous local initiatives, from supporting small businesses to improving public infrastructure. He believes in a common-sense approach to problem-solving and is dedicated to ensuring that the voices of all residents are heard. His vision for the county is one of a smart growth, economic prosperity, and a high quality of life for all.\n\nAs a husband and father, Curtis understands the importance of building a strong and vibrant community for future generations. He is a firm believer in the power of collaboration and is committed to working with residents, business leaders, and community organizations to create a better future for our county.",
    aboutPageBioImage1Path: "assets/images/Emmons_About_Bio1.png",
    aboutPageBioImage2Path: "assets/images/Emmons_About_Bio2.png",
    aboutPageBioImage3Path: "assets/images/Emmons_About_Bio3.png",
    endorsementsPageTitle: "Endorsements",
    endorsementsPageSubtitle: "Distinguished Supporters",
    endorsementsPageHeroImagePath: "assets/images/Emmons_Endorsements_Hero.png",
    communityEndorsersTitle: "Community Endorsers",
    addYourVoiceTitle: "Add Your Voice!",
    addYourVoiceSubtitle: "Show your support for Curtis Emmons by providing your endorsement. Your voice matters!",
    donatePageTitle: "Donate to the Campaign",
    donatePageSubtitle: "Support our Mission!",
    donatePageHeroImagePath: "assets/images/Emmons_Donate_Hero.png",
    donatePageMailInstructions: 'If you prefer to donate by mail, please send a check payable to "Curtis Emmons Campaign" to: 123 Main Street, Anytown, USA 12345',
    donatePageThankYouText: "Thank you for your generosity!",
    footerText: "Paid for by Elect Emmons",
    signupFormTitle: "Join the Movement!",
    signupFormEndorseCheckboxLabel: "I endorse Curtis Emmons and allow him to publish my endorsement",
    signupFormInvolvedCheckboxLabel: "I want to get involved with the campaign!",
    signupFormMessagingCheckboxLabel: "I agree to receive automated messaging from Elect Emmons",
    signupFormEmailCheckboxLabel: "I agree to receive emails from Elect Emmons",
    signupFormSmsDisclaimer: "Reply STOP to opt out, HELP for help. Msg & data rates may apply. Frequency may vary.",
    signupFormSubmitButtonLabel: "Sign Up",
    donateSectionTitle: "Make a Difference!",
    donationWidgetContinueButtonLabel: "Continue",
    donationWidgetProceedButtonLabel: "Proceed to Payment",
    donationWidgetCoverFeesCheckboxLabel: "Cover transaction fees",
    donationWidgetRecurringCheckboxLabel: "Make this a recurring monthly donation",
    donationWidgetContactEmailCheckboxLabel: "Contact me via Email",
    donationWidgetContactPhoneCheckboxLabel: "Contact me via Phone Call",
    donationWidgetContactMailCheckboxLabel: "Contact me via Mail",
    donationWidgetContactSmsCheckboxLabel: "Contact me via SMS",
    donationWidgetSubmitButtonLabel: "Submit"
  ),
  issues: const [
    Issue(
      title: "Affordable Healthcare",
      description: "Healthcare is a right, not a privilege...",
      imageUrl: "https://storage.googleapis.com/campaign-assets/emmons/healthcare.jpg"
    ),
    Issue(
      title: "Education Reform",
      description: "Investing in our schools is investing in our future...",
      imageUrl: "https://storage.googleapis.com/campaign-assets/emmons/education.jpg"
    )
  ],
  endorsements: const [
    Endorsement(
      endorserName: "Jane Doe",
      quote: "Curtis has the vision and dedication Bell County needs. He has my full support!",
      logoUrl: "assets/images/Emmons_Endorsements_Issue1.png"
    ),
     Endorsement(
      endorserName: "John Smith",
      quote: "I've worked with Curtis for years, and his commitment to our community is unwavering.",
      logoUrl: "assets/images/Emmons_Endorsements_Issue2.png"
    )
  ],
  communityEndorsers: const [
    'Michael Brown', 'Emily Davis', 'David Wilson', 'Sarah Miller',
    'Robert Garcia', 'Linda Rodriguez', 'James Martinez', 'Patricia Hernandez',
    'Christopher Lee', 'Jessica Gonzalez', 'Daniel Walker', 'Karen Hall',
  ],
  homePageSections: const [
    HomePageSectionConfig(
      title: 'Issues',
      summary: 'Learn about the key issues Curtis is focused on to improve our precinct.',
      imagePath: 'assets/images/Emmons_Home_Issues_Preview.png',
      routePath: '/issues',
      imageBackgroundColor: Colors.blueGrey,
      imageLeft: true,
      backgroundColor: Color(0xffa01124),
      textColor: Colors.white,
      buttonColor: Colors.white,
      buttonTextColor: Color(0xff002663),
    ),
    HomePageSectionConfig(
      title: 'About Me',
      summary: 'Discover more about Curtis Emmons, his background, and his vision for Bell County.',
      imagePath: 'assets/images/Emmons_Home_About_Preview.png',
      routePath: '/about',
      imageBackgroundColor: Colors.teal,
      imageLeft: false,
    ),
    HomePageSectionConfig(
      title: 'Endorsements',
      summary: 'See who is endorsing Curtis and learn how you can add your support.',
      imagePath: 'assets/images/Emmons_Home_Endorsements_Preview.png',
      routePath: '/endorsements',
      imageBackgroundColor: Colors.amber,
      imageLeft: true,
      backgroundColor: Color(0xff002663),
      textColor: Colors.white,
      buttonColor: Colors.white,
      buttonTextColor: Color(0xffa01124),
    ),
    HomePageSectionConfig(
      title: 'Donate',
      summary: 'Support the campaign financially and help us make a difference.',
      imagePath: 'assets/images/Emmons_Home_Donate_Preview.png',
      routePath: '/donate',
      imageBackgroundColor: Colors.green,
      imageLeft: false,
    ),
  ]
);

final blairCampaign = CampaignConfig(
  campaignId: "blair-2025",
  domain: "blairforcounty.com",
  siteTitle: "Blair for County | Common Sense Leadership",
  apiBaseUrl: "https://api.blairforcounty.com/api/v1",
  theme: ThemeData(
    primaryColor: const Color(0xFF4A90E2),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF4A90E2),
      secondary: const Color(0xFF34495E),
    ),
    fontFamily: "Lato",
  ),
  stripe: const StripeConfig(
    publicKey: "pk_test_blair123",
    connectedAccountId: "acct_blair456"
  ),
  content: const ContentConfig(
    heroTitle: "A New Day for Our County",
    heroSubtitle: "Experience and Integrity.",
    callToActionLabel: "Get Involved",
    welcomeTitle: "Welcome to the Blair Campaign",
    welcomeSubtitle: "Working together for a better future for our county.",
    issuesPageHeroImagePath: "assets/images/blair_issues_hero_placeholder.png",
    issuesPageTitle: "Priorities",
    aboutPageTitle: "About Blair",
    aboutPageSubtitle: "About Blair",
    aboutPageHeroImagePath: "assets/images/blair_about_hero_placeholder.png",
    aboutPageBio: "Placeholder biography for the Blair campaign. This text describes the candidate's background, values, and vision for the county.",
    aboutPageBioImage1Path: "assets/images/blair_bio1_placeholder.png",
    aboutPageBioImage2Path: "assets/images/blair_bio2_placeholder.png",
    aboutPageBioImage3Path: "assets/images/blair_bio3_placeholder.png",
    endorsementsPageTitle: "Endorsements",
    endorsementsPageSubtitle: "Our Supporters",
    endorsementsPageHeroImagePath: "assets/images/blair_endorsements_hero_placeholder.png",
    communityEndorsersTitle: "Community Supporters",
    addYourVoiceTitle: "Add Your Name",
    addYourVoiceSubtitle: "Show your support for Blair by adding your name to our list of endorsers.",
    donatePageTitle: "Support the Campaign",
    donatePageSubtitle: "Help us make a difference.",
    donatePageHeroImagePath: "assets/images/blair_donate_hero_placeholder.png",
    donatePageMailInstructions: 'To donate by mail, please send a check to "Blair for County Campaign" at: 456 Town Square, Anycity, USA 54321',
    donatePageThankYouText: "Your support is greatly appreciated!",
    footerText: "Paid for by Blair for County",
    signupFormTitle: "Join Our Team",
    signupFormEndorseCheckboxLabel: "I endorse Blair and allow them to publish my endorsement",
    signupFormInvolvedCheckboxLabel: "I want to volunteer for the campaign",
    signupFormMessagingCheckboxLabel: "I agree to receive automated texts from the Blair campaign",
    signupFormEmailCheckboxLabel: "I agree to receive emails from the Blair campaign",
    signupFormSmsDisclaimer: "Reply STOP to opt out. Msg & data rates may apply.",
    signupFormSubmitButtonLabel: "Submit",
    donateSectionTitle: "Support Our Cause",
    donationWidgetContinueButtonLabel: "Continue",
    donationWidgetProceedButtonLabel: "Proceed to Payment",
    donationWidgetCoverFeesCheckboxLabel: "Help cover transaction fees",
    donationWidgetRecurringCheckboxLabel: "Make it a monthly gift",
    donationWidgetContactEmailCheckboxLabel: "Keep me updated via Email",
    donationWidgetContactPhoneCheckboxLabel: "Keep me updated via Phone Call",
    donationWidgetContactMailCheckboxLabel: "Keep me updated via Mail",
    donationWidgetContactSmsCheckboxLabel: "Keep me updated via SMS",
    donationWidgetSubmitButtonLabel: "Complete Donation"
  ),
  issues: const [
    Issue(
      title: "Fiscal Responsibility",
      description: "Ensuring our county's budget is balanced and transparent.",
      imageUrl: "assets/images/blair_issue1_placeholder.png"
    ),
    Issue(
      title: "Public Safety",
      description: "Working with law enforcement to keep our communities safe.",
      imageUrl: "assets/images/blair_issue2_placeholder.png"
    )
  ],
  endorsements: const [
    Endorsement(
      endorserName: "Local Business Owner's Association",
      quote: "'Blair has the experience to lead us forward.'",
      logoUrl: "assets/images/blair_endorsement1_placeholder.png"
    )
  ],
  communityEndorsers: const [
    'John Doe', 'Jane Smith', 'Peter Jones'
  ],
  homePageSections: const [
      HomePageSectionConfig(
      title: 'Priorities',
      summary: 'Learn about the key priorities for our county.',
      imagePath: 'assets/images/blair_home_issues_placeholder.png',
      routePath: '/issues',
      imageBackgroundColor: Colors.blueGrey,
      imageLeft: true,
    ),
    HomePageSectionConfig(
      title: 'About Blair',
      summary: 'Discover more about the candidate.',
      imagePath: 'assets/images/blair_home_about_placeholder.png',
      routePath: '/about',
      imageBackgroundColor: Colors.teal,
      imageLeft: false,
    ),
  ]
);

// A map to easily access campaigns by their domain.
final Map<String, CampaignConfig> campaignsByDomain = {
  emmonsCampaign.domain: emmonsCampaign,
  blairCampaign.domain: blairCampaign,
  'localhost': emmonsCampaign, // Default for local development
};
