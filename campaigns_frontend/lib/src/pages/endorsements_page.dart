import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campaigns_frontend/src/widgets/dynamic_size_app_bar.dart';
import 'package:campaigns_frontend/src/widgets/common_app_bar.dart';
import 'package:campaigns_frontend/src/widgets/signup_form.dart';
import 'package:campaigns_frontend/src/widgets/donate_section.dart';
import 'package:campaigns_frontend/src/widgets/high_profile_endorsement_card.dart';
import 'package:campaigns_frontend/src/widgets/footer.dart';
import 'package:campaigns_frontend/src/utils/breakpoint.dart';
import 'package:campaigns_frontend/src/providers.dart';

class EndorsementsPage extends ConsumerWidget {
  const EndorsementsPage({super.key});

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
            title: config.endorsementsPageText.heroTitle,
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
                      image: AssetImage('images/Emmons_Endorsements_Hero.png'), // This will be replaced by a config value
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
                  config.endorsementsPageText.heroTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  'Distinguished Supporters',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < config.numberOfDistinguishedEndorsements; i++)
                  HighProfileEndorsementCard(
                    name: config.endorsementsPageText.distinguishedEndorsements[i].name,
                    quote: config.endorsementsPageText.distinguishedEndorsements[i].title,
                    imagePath: config.endorsementsPageText.distinguishedEndorsements[i].imagePath,
                    backgroundColor: i % 2 == 0 ? config.primaryColor : config.secondaryColor,
                    textColor: Colors.white,
                    imageLeft: i % 2 == 0,
                  ),
                const SizedBox(height: 40),
                Text(
                  'Community Endorsers',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildEndorserList(context, config.endorsementsPageText.endorsements.map((e) => e.name).toList()),
                const SizedBox(height: 40),
                Text(
                  'Add Your Voice!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Show your support for ${config.campaignName} by providing your endorsement. Your voice matters!',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                const DonateSection(),
                const SizedBox(height: 40),
                const SignupFormWidget(),
                const SizedBox(height: 40),
                const Footer(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEndorserList(BuildContext context, List<String> endorsers) {
    final textTheme = Theme.of(context).textTheme;
    if (endorsers.isEmpty) {
      return Text(
        'More endorsements coming soon!',
        style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      );
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      alignment: WrapAlignment.center,
      children: endorsers.map((name) {
        return Chip(label: Text(name));
      }).toList(),
    );
  }
}
