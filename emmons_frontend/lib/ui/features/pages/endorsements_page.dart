import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emmons_frontend/main.dart'; // For campaignProvider
import 'package:emmons_frontend/ui/core_widgets/widgets/dynamic_size_app_bar.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/common_app_bar.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/signup_form.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/donate_section.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/high_profile_endorsement_card.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/footer.dart';
import 'package:emmons_frontend/core/utils/breakpoint.dart';

class EndorsementsPage extends ConsumerStatefulWidget {
  const EndorsementsPage({super.key});
  @override
  EndorsementsPageState createState() => EndorsementsPageState();
}

class EndorsementsPageState extends ConsumerState<EndorsementsPage> {
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
            title: campaignConfig.content.endorsementsPageTitle,
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
                      image: AssetImage(campaignConfig.content.endorsementsPageHeroImagePath),
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
                  campaignConfig.content.endorsementsPageTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  campaignConfig.content.endorsementsPageSubtitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ...campaignConfig.endorsements.asMap().entries.map((entry) {
                   int idx = entry.key;
                   var endorsement = entry.value;
                   return HighProfileEndorsementCard(
                     name: endorsement.endorserName,
                     quote: endorsement.quote,
                     imagePath: endorsement.logoUrl,
                     imageLeft: idx % 2 == 0,
                     backgroundColor: idx % 2 != 0 ? campaignConfig.theme.primaryColor : null,
                     textColor: idx % 2 != 0 ? Colors.white : null,
                   );
                }),
                const SizedBox(height: 40),
                Text(
                  campaignConfig.content.communityEndorsersTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildEndorserList(context, campaignConfig.communityEndorsers),
                const SizedBox(height: 40),
                Text(
                  campaignConfig.content.addYourVoiceTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    campaignConfig.content.addYourVoiceSubtitle,
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
