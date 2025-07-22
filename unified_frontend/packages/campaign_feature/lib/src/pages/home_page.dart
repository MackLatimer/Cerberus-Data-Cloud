import 'package:flutter/material.dart';
import 'package:campaign_feature/src/widgets/dynamic_size_app_bar.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:campaign_feature/src/widgets/donate_section.dart';
import 'package:campaign_feature/src/widgets/home_page_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

      // extended
      if (width > 1000) {
        appBarHeight = 156;
        // medium
      } else if (width > 600) {
        appBarHeight = 216;
        // compact
      } else {
        appBarHeight = 256;
      }
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: DynamicSizeAppBar(
          height: appBarHeight,
          child: CommonAppBar(
            title: 'Curtis Emmons for Bell County Precinct 4',
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
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Hero_Picture_Home.png'),
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
              const HomePageSection(
                title: 'Issues',
                summary:
                    'Learn about the key issues Curtis is focused on to improve our precinct.',
                imagePath: 'assets/Summary_Picture_Issues.png',
                routePath: '/issues',
                imageBackgroundColor: Colors.blueGrey,
                imageLeft: true,
                backgroundColor: AppColors.secondary,
                textColor: AppColors.onSecondary,
                buttonColor: AppColors.onSecondary,
                buttonTextColor: AppColors.primary,
              ),
              const HomePageSection(
                title: 'About Me',
                summary:
                    'Discover more about Curtis Emmons, his background, and his vision for Bell County.',
                imagePath: 'assets/Summary_Picture_About.png',
                routePath: '/about',
                imageBackgroundColor: Colors.teal,
                imageLeft: false,
              ),
              const HomePageSection(
                title: 'Endorsements',
                summary:
                    'See who is endorsing Curtis and learn how you can add your support.',
                imagePath: 'assets/Summary_Picture_Endorsements.png',
                routePath: '/endorsements',
                imageBackgroundColor: Colors.amber,
                imageLeft: true,
                backgroundColor: AppColors.primary,
                textColor: AppColors.onPrimary,
                buttonColor: AppColors.onPrimary,
                buttonTextColor: AppColors.secondary,
              ),
              const HomePageSection(
                title: 'Donate',
                summary:
                    'Support the campaign financially and help us make a difference.',
                imagePath: 'assets/Summary_Picture_Donate.png',
                routePath: '/donate',
                imageBackgroundColor: Colors.green,
                imageLeft: false,
              ),
              const DonateSection(),
              const SignupForm(),
              const Footer(),
            ],
          ),
        ),
      ),
      );
    });
  }
}
