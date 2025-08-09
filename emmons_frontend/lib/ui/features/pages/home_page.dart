import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emmons_frontend/main.dart'; // For campaignProvider
import 'package:emmons_frontend/ui/core_widgets/widgets/dynamic_size_app_bar.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/common_app_bar.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/signup_form.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/donate_section.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/home_page_section.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/footer.dart';
import 'package:emmons_frontend/core/utils/breakpoint.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaignConfig = ref.watch(campaignProvider);
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
            title: campaignConfig.siteTitle,
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
                    image: AssetImage('assets/images/Emmons_Home_Hero.png'), // This could also be in config
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
                campaignConfig.content.welcomeTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  campaignConfig.content.welcomeSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              ...campaignConfig.homePageSections.map((sectionConfig) {
                return HomePageSection(
                  title: sectionConfig.title,
                  summary: sectionConfig.summary,
                  imagePath: sectionConfig.imagePath,
                  routePath: sectionConfig.routePath,
                  imageBackgroundColor: sectionConfig.imageBackgroundColor,
                  imageLeft: sectionConfig.imageLeft,
                  backgroundColor: sectionConfig.backgroundColor,
                  textColor: sectionConfig.textColor,
                  buttonColor: sectionConfig.buttonColor,
                  buttonTextColor: sectionConfig.buttonTextColor,
                );
              }).toList(),
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
