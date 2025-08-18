import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_campaign_frontend/providers/campaign_provider.dart';
import 'package:universal_campaign_frontend/widgets/common_app_bar.dart';
import 'package:universal_campaign_frontend/widgets/signup_form.dart';
import 'package:universal_campaign_frontend/widgets/donate_section.dart';
import 'package:universal_campaign_frontend/widgets/home_page_section.dart';
import 'package:universal_campaign_frontend/widgets/footer.dart';
import 'package:universal_campaign_frontend/utils/breakpoint.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<CampaignProvider>(context).campaignConfig!;
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;
    final heroHeight = isCompact ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height;
    final ScrollController scrollController = ScrollController();

    final double screenWidth = MediaQuery.of(context).size.width;
    double appBarHeight;
    if (screenWidth < 600) {
      appBarHeight = 240.0; // Compact
    } else if (screenWidth < 1000) {
      appBarHeight = 190.0; // Medium
    } else {
      appBarHeight = 120.0; // Normal
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        config: config,
        scrollController: scrollController,
        appBarHeight: appBarHeight, // Pass the calculated height
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: heroHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(config.content.homePage.heroImagePath.isNotEmpty ? config.content.homePage.heroImagePath : 'assets/images/error_placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 40),
              Text(
                config.content.homePage.heroTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  config.content.homePage.callToActionText,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              HomePageSection(
                title: 'Issues',
                summary: config.content.homePage.issuesMessage,
                imagePath: config.content.homePage.issuesImage,
                routePath: '/issues',
                buttonText: config.content.homePage.issuesButton,
                imageBackgroundColor: Color(int.parse(config.theme.issuesSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                imageLeft: true,
                backgroundColor: Color(int.parse(config.theme.issuesSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                textColor: Color(int.parse(config.theme.issuesSectionTheme.textColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonColor: Color(int.parse(config.theme.issuesSectionTheme.buttonColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonTextColor: Color(int.parse(config.theme.issuesSectionTheme.buttonTextColor.substring(1, 7), radix: 16) + 0xFF000000),
              ),
              HomePageSection(
                title: 'About Me',
                summary: config.content.homePage.aboutMeMessage,
                imagePath: config.content.homePage.aboutMeImage,
                routePath: '/about',
                buttonText: config.content.homePage.aboutMeButton,
                imageBackgroundColor: Color(int.parse(config.theme.aboutMeSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                imageLeft: false,
                backgroundColor: Color(int.parse(config.theme.aboutMeSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                textColor: Color(int.parse(config.theme.aboutMeSectionTheme.textColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonColor: Color(int.parse(config.theme.aboutMeSectionTheme.buttonColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonTextColor: Color(int.parse(config.theme.aboutMeSectionTheme.buttonTextColor.substring(1, 7), radix: 16) + 0xFF000000),
              ),
              HomePageSection(
                title: 'Endorsements',
                summary: config.content.homePage.endorsementsMessage,
                imagePath: config.content.homePage.endorsementsImage,
                routePath: '/endorsements',
                buttonText: config.content.homePage.endorsementsButton,
                imageBackgroundColor: Color(int.parse(config.theme.endorsementsSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                imageLeft: true,
                backgroundColor: Color(int.parse(config.theme.endorsementsSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                textColor: Color(int.parse(config.theme.endorsementsSectionTheme.textColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonColor: Color(int.parse(config.theme.endorsementsSectionTheme.buttonColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonTextColor: Color(int.parse(config.theme.endorsementsSectionTheme.buttonTextColor.substring(1, 7), radix: 16) + 0xFF000000),
              ),
              HomePageSection(
                title: 'Donate',
                summary: config.content.homePage.donateMessage,
                imagePath: config.content.homePage.donateImage,
                routePath: '/donate',
                buttonText: config.content.homePage.donateButton,
                imageBackgroundColor: Color(int.parse(config.theme.donateSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                imageLeft: false,
                backgroundColor: Color(int.parse(config.theme.donateSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                textColor: Color(int.parse(config.theme.donateSectionTheme.textColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonColor: Color(int.parse(config.theme.donateSectionTheme.buttonColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonTextColor: Color(int.parse(config.theme.donateSectionTheme.buttonTextColor.substring(1, 7), radix: 16) + 0xFF000000),
              ),
              DonateSection(config: config),
              SignupFormWidget(config: config),
              Footer(config: config),
            ]),
          ),
        ],
      ),
    );
  }
}