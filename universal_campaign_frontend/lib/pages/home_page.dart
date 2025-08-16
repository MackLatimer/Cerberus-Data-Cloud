import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/widgets/common_app_bar.dart';
import 'package:universal_campaign_frontend/widgets/signup_form.dart';
import 'package:universal_campaign_frontend/widgets/donate_section.dart';
import 'package:universal_campaign_frontend/widgets/home_page_section.dart';
import 'package:universal_campaign_frontend/widgets/footer.dart';
import 'package:universal_campaign_frontend/utils/breakpoint.dart';
import 'package:universal_campaign_frontend/models/campaign_config.dart';

class HomePage extends StatefulWidget {
  final CampaignConfig config;
  const HomePage({super.key, required this.config});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;
    final heroHeight = isCompact ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        config: widget.config,
        scrollController: _scrollController,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: heroHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.config.content.homePage.heroImagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 40),
              Text(
                widget.config.content.homePage.heroTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  widget.config.content.homePage.callToActionText,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              HomePageSection(
                title: 'Issues',
                summary: widget.config.content.homePage.issuesMessage,
                imagePath: widget.config.content.homePage.issuesImage,
                routePath: '/issues',
                imageBackgroundColor: Color(int.parse(widget.config.theme.issuesSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                imageLeft: true,
                backgroundColor: Color(int.parse(widget.config.theme.issuesSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                textColor: Color(int.parse(widget.config.theme.issuesSectionTheme.textColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonColor: Color(int.parse(widget.config.theme.issuesSectionTheme.buttonColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonTextColor: Color(int.parse(widget.config.theme.issuesSectionTheme.buttonTextColor.substring(1, 7), radix: 16) + 0xFF000000),
              ),
              HomePageSection(
                title: 'About Me',
                summary: widget.config.content.homePage.aboutMeMessage,
                imagePath: widget.config.content.homePage.aboutMeImage,
                routePath: '/about',
                imageBackgroundColor: Color(int.parse(widget.config.theme.aboutMeSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                imageLeft: false,
                backgroundColor: Color(int.parse(widget.config.theme.aboutMeSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                textColor: Color(int.parse(widget.config.theme.aboutMeSectionTheme.textColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonColor: Color(int.parse(widget.config.theme.aboutMeSectionTheme.buttonColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonTextColor: Color(int.parse(widget.config.theme.aboutMeSectionTheme.buttonTextColor.substring(1, 7), radix: 16) + 0xFF000000),
              ),
              HomePageSection(
                title: 'Endorsements',
                summary: widget.config.content.homePage.endorsementsMessage,
                imagePath: widget.config.content.homePage.endorsementsImage,
                routePath: '/endorsements',
                imageBackgroundColor: Color(int.parse(widget.config.theme.endorsementsSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                imageLeft: true,
                backgroundColor: Color(int.parse(widget.config.theme.endorsementsSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                textColor: Color(int.parse(widget.config.theme.endorsementsSectionTheme.textColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonColor: Color(int.parse(widget.config.theme.endorsementsSectionTheme.buttonColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonTextColor: Color(int.parse(widget.config.theme.endorsementsSectionTheme.buttonTextColor.substring(1, 7), radix: 16) + 0xFF000000),
              ),
              HomePageSection(
                title: 'Donate',
                summary: widget.config.content.homePage.donateMessage,
                imagePath: widget.config.content.homePage.donateImage,
                routePath: '/donate',
                imageBackgroundColor: Color(int.parse(widget.config.theme.donateSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                imageLeft: false,
                backgroundColor: Color(int.parse(widget.config.theme.donateSectionTheme.backgroundColor.substring(1, 7), radix: 16) + 0xFF000000),
                textColor: Color(int.parse(widget.config.theme.donateSectionTheme.textColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonColor: Color(int.parse(widget.config.theme.donateSectionTheme.buttonColor.substring(1, 7), radix: 16) + 0xFF000000),
                buttonTextColor: Color(int.parse(widget.config.theme.donateSectionTheme.buttonTextColor.substring(1, 7), radix: 16) + 0xFF000000),
              ),
              DonateSection(config: widget.config),
              SignupFormWidget(config: widget.config),
              Footer(config: widget.config),
            ]),
          ),
        ],
      ),
    );
  }
}

