import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/widgets/dynamic_size_app_bar.dart';
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

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      double appBarHeight;

      if (width > 1000) {
        appBarHeight = 156;
      } else if (width > 600) {
        appBarHeight = 216;
      } else {
        appBarHeight = 256;
      }
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: DynamicSizeAppBar(
          height: appBarHeight,
          child: CommonAppBar(
            config: widget.config,
            scrollController: _scrollController,
          ),
        ),
        body: NestedScrollView(
          controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: heroHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.config.assets.homePage.heroImagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                summary:
                    'Learn about the key issues Curtis is focused on to improve our precinct.',
                imagePath: 'assets/images/Emmons_Home_Issues_Preview.png',
                routePath: '/issues',
                imageBackgroundColor: Colors.blueGrey,
                imageLeft: true,
                backgroundColor: const Color(0xffa01124),
                textColor: Colors.white,
                buttonColor: Colors.white,
                buttonTextColor: const Color(0xff002663),
              ),
              const HomePageSection(
                title: 'About Me',
                summary:
                    'Discover more about Curtis Emmons, his background, and his vision for Bell County.',
                imagePath: 'assets/images/Emmons_Home_About_Preview.png',
                routePath: '/about',
                imageBackgroundColor: Colors.teal,
                imageLeft: false,
              ),
              const HomePageSection(
                title: 'Endorsements',
                summary:
                    'See who is endorsing Curtis and learn how you can add your support.',
                imagePath: 'assets/images/Emmons_Home_Endorsements_Preview.png',
                routePath: '/endorsements',
                imageBackgroundColor: Colors.amber,
                imageLeft: true,
                backgroundColor: Color(0xff002663),
                textColor: Colors.white,
                buttonColor: Colors.white,
                buttonTextColor: Color(0xffa01124),
              ),
              const HomePageSection(
                title: 'Donate',
                summary:
                    'Support the campaign financially and help us make a difference.',
                imagePath: 'assets/images/Emmons_Home_Donate_Preview.png',
                routePath: '/donate',
                imageBackgroundColor: Colors.green,
                imageLeft: false,
              ),
              DonateSection(config: widget.config),
              SignupFormWidget(config: widget.config),
              Footer(config: widget.config),
            ],
          ),
        ),
      ),
      );
    });
  }
}

