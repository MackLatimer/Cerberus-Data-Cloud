import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_campaign_frontend/providers/campaign_provider.dart';
import 'package:universal_campaign_frontend/widgets/common_app_bar.dart';
import 'package:universal_campaign_frontend/widgets/signup_form.dart';
import 'package:universal_campaign_frontend/widgets/donate_section.dart';
import 'package:universal_campaign_frontend/widgets/high_profile_endorsement_card.dart';
import 'package:universal_campaign_frontend/widgets/footer.dart';
import 'package:universal_campaign_frontend/utils/breakpoint.dart';


class EndorsementsPage extends StatelessWidget {
  const EndorsementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<CampaignProvider>(context).campaignConfig!;
    final ScrollController scrollController = ScrollController();
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;
    final heroHeight = isCompact ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height;

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
                  image: AssetImage(config.content.endorsementsPage.heroImagePath.isNotEmpty ? config.content.endorsementsPage.heroImagePath : 'assets/images/Blair_Logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              for (int i = 0; i < config.content.endorsementsPage.endorsements.length; i++)
                HighProfileEndorsementCard(
                  name: config.content.endorsementsPage.endorsements[i].name,
                  quote: config.content.endorsementsPage.endorsements[i].quote,
                  imagePath: config.content.endorsementsPage.endorsements[i].imagePath,
                  imageLeft: config.content.endorsementsPage.endorsements[i].imageLeft,
                  backgroundColor: config.content.endorsementsPage.endorsements[i].backgroundColor != null
                      ? Color(int.parse(config.content.endorsementsPage.endorsements[i].backgroundColor!.substring(1, 7), radix: 16) + 0xFF000000)
                      : null,
                  textColor: config.content.endorsementsPage.endorsements[i].textColor != null
                      ? Color(int.parse(config.content.endorsementsPage.endorsements[i].textColor!.substring(1, 7), radix: 16) + 0xFF000000)
                      : null,
                ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      config.content.endorsementsPage.communityTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: config.content.endorsementsPage.communityEndorsements
                          .map((name) => Chip(label: Text(name)))
                          .toList(),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      config.content.endorsementsPage.endorsementCallToAction,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      config.content.endorsementsPage.endorsementCallToActionText,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
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
