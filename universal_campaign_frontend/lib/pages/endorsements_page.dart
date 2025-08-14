import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/widgets/dynamic_size_app_bar.dart';
import 'package:universal_campaign_frontend/widgets/common_app_bar.dart';
import 'package:universal_campaign_frontend/widgets/signup_form.dart';
import 'package:universal_campaign_frontend/widgets/donate_section.dart';
import 'package:universal_campaign_frontend/widgets/high_profile_endorsement_card.dart';
import 'package:universal_campaign_frontend/widgets/footer.dart';
import 'package:universal_campaign_frontend/utils/breakpoint.dart';
import 'package:universal_campaign_frontend/models/campaign_config.dart';

class EndorsementsPage extends StatefulWidget {
  final CampaignConfig config;
  const EndorsementsPage({super.key, required this.config});

  @override
  EndorsementsPageState createState() => EndorsementsPageState();
}

class EndorsementsPageState extends State<EndorsementsPage> {
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
                    image: AssetImage(widget.config.assets.endorsementsPage.heroImagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 40),
                        Text(
                          widget.config.content.endorsementsPage.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // High Profile Endorsements
                        for (int i = 0; i < widget.config.content.endorsementsPage.endorsements.length; i++)
                          HighProfileEndorsementCard(
                            name: widget.config.content.endorsementsPage.endorsements[i].name,
                            quote: widget.config.content.endorsementsPage.endorsements[i].quote,
                            imagePath: widget.config.content.endorsementsPage.endorsements[i].imagePath,
                            imageLeft: widget.config.content.endorsementsPage.endorsements[i].imageLeft,
                            backgroundColor: widget.config.content.endorsementsPage.endorsements[i].backgroundColor != null
                                ? Color(int.parse(widget.config.content.endorsementsPage.endorsements[i].backgroundColor.substring(1, 7), radix: 16) + 0xFF000000)
                                : null,
                            textColor: widget.config.content.endorsementsPage.endorsements[i].textColor != null
                                ? Color(int.parse(widget.config.content.endorsementsPage.endorsements[i].textColor.substring(1, 7), radix: 16) + 0xFF000000)
                                : null,
                          ),
                        const SizedBox(height: 40),
                        // Community Endorsements
                        for (var endorsement in widget.config.content.endorsementsPage.communityEndorsements)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '"$endorsement" - ',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                    ),
                  ),
                ),
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
