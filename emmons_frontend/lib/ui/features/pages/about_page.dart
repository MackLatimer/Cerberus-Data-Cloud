import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emmons_frontend/main.dart'; // For campaignProvider
import 'package:emmons_frontend/ui/core_widgets/widgets/dynamic_size_app_bar.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/common_app_bar.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/signup_form.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/donate_section.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/footer.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({super.key});

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends ConsumerState<AboutPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaignConfig = ref.watch(campaignProvider);

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
            title: campaignConfig.content.aboutPageTitle,
            scrollController: _scrollController,
          ),
        ),
        body: NestedScrollView(
          controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(campaignConfig.content.aboutPageHeroImagePath),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          campaignConfig.content.aboutPageSubtitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          campaignConfig.content.aboutPageBio,
                          style: const TextStyle(fontSize: 18, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(campaignConfig.content.aboutPageBioImage1Path, fit: BoxFit.cover)),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(campaignConfig.content.aboutPageBioImage2Path, fit: BoxFit.cover)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(campaignConfig.content.aboutPageBioImage3Path, height: 200, fit: BoxFit.cover)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
