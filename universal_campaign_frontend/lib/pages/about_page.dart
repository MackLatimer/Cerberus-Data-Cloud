import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_campaign_frontend/providers/campaign_provider.dart';
import 'package:universal_campaign_frontend/widgets/common_app_bar.dart';
import 'package:universal_campaign_frontend/widgets/signup_form.dart';
import 'package:universal_campaign_frontend/widgets/donate_section.dart';
import 'package:universal_campaign_frontend/widgets/footer.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<CampaignProvider>(context).campaignConfig!;
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
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(config.assets.aboutPage.heroImagePath.isNotEmpty ? config.assets.aboutPage.heroImagePath : 'assets/images/Blair_Logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
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
                          config.content.aboutPage.bioTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          config.content.aboutPage.bioParagraph1,
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
                                  child: Image.asset(config.assets.aboutPage.bioImage1Path.isNotEmpty ? config.assets.aboutPage.bioImage1Path : 'assets/images/Blair_Logo.png', fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(config.assets.aboutPage.bioImage2Path.isNotEmpty ? config.assets.aboutPage.bioImage2Path : 'assets/images/Blair_Logo.png', fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          config.content.aboutPage.bioParagraph2,
                          style: const TextStyle(fontSize: 18, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(config.assets.aboutPage.bioImage3Path.isNotEmpty ? config.assets.aboutPage.bioImage3Path : 'assets/images/Blair_Logo.png', fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          config.content.aboutPage.bioParagraph3,
                          style: const TextStyle(fontSize: 18, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
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
