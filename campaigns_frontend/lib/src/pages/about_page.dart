import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campaigns_frontend/src/widgets/dynamic_size_app_bar.dart';
import 'package:campaigns_frontend/src/widgets/common_app_bar.dart';
import 'package:campaigns_frontend/src/widgets/signup_form.dart';
import 'package:campaigns_frontend/src/widgets/donate_section.dart';
import 'package:campaigns_frontend/src/widgets/footer.dart';
import 'package:campaigns_frontend/src/providers.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(campaignConfigProvider);
    final scrollController = ScrollController();

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
            title: config.aboutPageText.heroTitle,
            scrollController: scrollController,
          ),
        ),
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/Emmons_About_Hero.png'), // This will be replaced by a config value
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
                            config.aboutPageText.heroTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          Text(
                            config.aboutPageText.bio1,
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
                                    child: Image.asset('images/Emmons_About_Bio1.png', fit: BoxFit.cover), // This will be replaced by a config value
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.asset('images/Emmons_About_Bio2.png', fit: BoxFit.cover), // This will be replaced by a config value
                                  ),
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
                                child: Image.asset('images/Emmons_About_Bio3.png', height: 200, fit: BoxFit.cover), // This will be replaced by a config value
                              ),
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
