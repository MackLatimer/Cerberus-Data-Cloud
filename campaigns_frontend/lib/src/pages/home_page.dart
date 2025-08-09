import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campaigns_frontend/src/widgets/dynamic_size_app_bar.dart';
import 'package:campaigns_frontend/src/widgets/common_app_bar.dart';
import 'package:campaigns_frontend/src/widgets/signup_form.dart';
import 'package:campaigns_frontend/src/widgets/donate_section.dart';
import 'package:campaigns_frontend/src/widgets/home_page_section.dart';
import 'package:campaigns_frontend/src/widgets/footer.dart';
import 'package:campaigns_frontend/src/utils/breakpoint.dart';
import 'package:campaigns_frontend/src/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(campaignConfigProvider);
    final scrollController = ScrollController();

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
            title: config.campaignName,
            scrollController: scrollController,
          ),
        ),
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  height: heroHeight,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Emmons_Home_Hero.png'), // This will be replaced by a config value
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
                  'Welcome to the Campaign!',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Join us in making a difference for Bell County Precinct 4. Curtis Emmons is dedicated to serving our community with integrity, transparency, and a commitment to progress.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                HomePageSection(
                  title: 'Issues',
                  summary: config.homePageText.issuesPreview,
                  imagePath: 'assets/images/Emmons_Home_Issues_Preview.png',
                  routePath: '/issues',
                  imageBackgroundColor: Colors.blueGrey,
                  imageLeft: true,
                  backgroundColor: config.primaryColor,
                  textColor: Colors.white,
                  buttonColor: Colors.white,
                  buttonTextColor: config.secondaryColor,
                ),
                HomePageSection(
                  title: 'About Me',
                  summary: config.homePageText.aboutPreview,
                  imagePath: 'assets/images/Emmons_Home_About_Preview.png',
                  routePath: '/about',
                  imageBackgroundColor: Colors.teal,
                  imageLeft: false,
                ),
                HomePageSection(
                  title: 'Endorsements',
                  summary: config.homePageText.endorsementsPreview,
                  imagePath: 'assets/images/Emmons_Home_Endorsements_Preview.png',
                  routePath: '/endorsements',
                  imageBackgroundColor: Colors.amber,
                  imageLeft: true,
                  backgroundColor: config.secondaryColor,
                  textColor: Colors.white,
                  buttonColor: Colors.white,
                  buttonTextColor: config.primaryColor,
                ),
                HomePageSection(
                  title: 'Donate',
                  summary: config.homePageText.donatePreview,
                  imagePath: 'assets/images/Emmons_Home_Donate_Preview.png',
                  routePath: '/donate',
                  imageBackgroundColor: Colors.green,
                  imageLeft: false,
                ),
                const DonateSection(),
                const SignupFormWidget(),
                const Footer(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
