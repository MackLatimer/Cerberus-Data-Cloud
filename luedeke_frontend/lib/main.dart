import 'package:flutter/material.dart';
import 'package:campaigns_frontend/main.dart' as app;
import 'package:campaign_config/campaign_config.dart';

void main() {
  final luedekeConfig = CampaignConfig(
    stripePublicKey: 'pk_test_51Rnnfv4brLkKMnfT9dQISZb1hLmvQMVq3nr8Ymb67lqFQ4JwJkTrc92dRUXKYvYs3tSMeYZkTgIkKJxLsOmjqTN800f2UFiJiT',
    campaignId: '7',
    campaignName: 'Luedeke Frontend',
    domain: 'placeholder.com',
    primaryColor: const Color(0xFF002663),
    secondaryColor: const Color(0xFFA01124),
    fontHeader: 'BebasNeue',
    fontBody: 'Tinos',
    homePageText: HomePageText(
      aboutPreview: 'Discover more about Curtis Emmons, his background, and his vision for Bell County.',
      issuesPreview: 'Learn about the key issues Curtis is focused on to improve our precinct.',
      endorsementsPreview: 'See who is endorsing Curtis and learn how you can add your support.',
      donatePreview: 'Support the campaign financially and help us make a difference.',
    ),
    issuesPageText: IssuesPageText(
      heroTitle: 'Key Issues',
      issues: [
        Issue(
          title: 'Economic Growth & Job Creation',
          content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Curtis believes in fostering a business-friendly environment that attracts new opportunities and supports local entrepreneurs.',
          imagePath: 'assets/images/Emmons_Issues_Issue1.png',
        ),
        Issue(
          title: 'Community Safety & Emergency Services',
          content: 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ensuring our neighborhoods are safe and our first responders are well-equipped is a top priority.',
          imagePath: 'assets/images/Emmons_Issues_Issue2.png',
        ),
        Issue(
          title: 'Infrastructure Development & Maintenance',
          content: 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. We must invest in maintaining and improving our roads, bridges, and public utilities to support our growing community.',
          imagePath: 'assets/images/Emmons_Issues_Issue3.png',
        ),
        Issue(
          title: 'Fiscal Responsibility & Transparent Governance',
          content: 'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Curtis is committed to responsible spending of taxpayer dollars and ensuring all county operations are transparent and accountable to the public.',
          imagePath: 'assets/images/Emmons_Issues_Issue4.png',
        ),
      ],
    ),
    endorsementsPageText: EndorsementsPageText(
      heroTitle: 'Endorsements',
      distinguishedEndorsements: [
        Endorsement(
          name: 'Jane Doe',
          title: 'Curtis has the vision and dedication Bell County needs. He has my full support!',
          imagePath: 'assets/images/Emmons_Endorsements_Issue1.png',
        ),
        Endorsement(
          name: 'John Smith',
          title: 'I\'ve worked with Curtis for years, and his commitment to our community is unwavering.',
          imagePath: 'assets/images/Emmons_Endorsements_Issue2.png',
        ),
        Endorsement(
          name: 'Bob Johnson',
          title: 'A true leader for our time.',
          imagePath: 'assets/images/Emmons_Endorsements_Issue3.png',
        ),
        Endorsement(
          name: 'Susan Williams',
          title: 'The best choice for Bell County.',
          imagePath: 'assets/images/Emmons_Endorsements_Issue4.png',
        ),
        Endorsement(
          name: 'Michael Brown',
          title: 'He will get the job done.',
          imagePath: 'assets/images/Endorsement_Picture_5.png',
        ),
      ],
      endorsements: [
        Endorsement(name: 'Michael Brown', title: '', imagePath: ''),
        Endorsement(name: 'Emily Davis', title: '', imagePath: ''),
        Endorsement(name: 'David Wilson', title: '', imagePath: ''),
        Endorsement(name: 'Sarah Miller', title: '', imagePath: ''),
        Endorsement(name: 'Robert Garcia', title: '', imagePath: ''),
        Endorsement(name: 'Linda Rodriguez', title: '', imagePath: ''),
        Endorsement(name: 'James Martinez', title: '', imagePath: ''),
        Endorsement(name: 'Patricia Hernandez', title: '', imagePath: ''),
        Endorsement(name: 'Christopher Lee', title: '', imagePath: ''),
        Endorsement(name: 'Jessica Gonzalez', title: '', imagePath: ''),
        Endorsement(name: 'Daniel Walker', title: '', imagePath: ''),
        Endorsement(name: 'Karen Hall', title: '', imagePath: ''),
      ],
    ),
    aboutPageText: AboutPageText(
      heroTitle: 'About Curtis Emmons',
      bio1: 'Curtis Emmons is a dedicated public servant with a passion for community development and effective governance. With a background in business and a commitment to fiscal responsibility, Curtis brings a wealth of experience to the table. He is a strong advocate for transparency and accountability in government, and he is committed to working collaboratively to find solutions to the challenges facing our county.\n\nThroughout his career, Curtis has been actively involved in numerous local initiatives, from supporting small businesses to improving public infrastructure. He believes in a common-sense approach to problem-solving and is dedicated to ensuring that the voices of all residents are heard. His vision for the county is one of a smart growth, economic prosperity, and a high quality of life for all.\n\nAs a husband and father, Curtis understands the importance of building a strong and vibrant community for future generations. He is a firm believer in the power of collaboration and is committed to working with residents, business leaders, and community organizations to create a better future for our county.',
      bio2: '',
      bio3: '',
    ),
    numberOfIssues: 4,
    numberOfDistinguishedEndorsements: 5,
  );

  app.main(config: emmonsConfig);
}
