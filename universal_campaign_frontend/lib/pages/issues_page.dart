import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/widgets/dynamic_size_app_bar.dart';
import 'package:universal_campaign_frontend/widgets/common_app_bar.dart';
import 'package:universal_campaign_frontend/widgets/signup_form.dart';
import 'package:universal_campaign_frontend/widgets/donate_section.dart';
import 'package:universal_campaign_frontend/widgets/footer.dart';
import 'package:universal_campaign_frontend/utils/breakpoint.dart';
import 'package:universal_campaign_frontend/models/campaign_config.dart';

class IssuesPage extends StatefulWidget {
  final CampaignConfig config;
  const IssuesPage({super.key, required this.config});

  @override
  IssuesPageState createState() => IssuesPageState();
}

class IssuesPageState extends State<IssuesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildIssueSection(
    BuildContext context,
    String title,
    String content, {
    required String imagePath,
    Color? backgroundColor,
    Color? textColor,
    bool imageLeft = true,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;

    final imageWidget = Container(
      height: isCompact ? 200 : 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );

    final textWidget = Container(
      height: isCompact ? null : 400,
      color: backgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold, color: textColor ?? Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style:
                textTheme.bodyLarge?.copyWith(color: textColor ?? Colors.black),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [imageWidget, textWidget],
      );
    }

    final imageExpanded = Expanded(child: imageWidget);
    final textExpanded = Expanded(child: textWidget);

    return SizedBox(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: imageLeft ? [imageExpanded, textExpanded] : [textExpanded, imageExpanded],
      ),
    );
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
                    image: AssetImage(widget.config.assets.issuesPage.heroImagePath),
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
                widget.config.content.issuesPage.title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              for (int i = 0; i < widget.config.content.issuesPage.issueSections.length; i++)
                _buildIssueSection(
                  context,
                  widget.config.content.issuesPage.issueSections[i].title,
                  widget.config.content.issuesPage.issueSections[i].description,
                  imagePath: widget.config.content.issuesPage.issueSections[i].imagePath,
                  backgroundColor: widget.config.content.issuesPage.issueSections[i].backgroundColor != null
                      ? Color(int.parse(widget.config.content.issuesPage.issueSections[i].backgroundColor!.substring(1, 7), radix: 16) + 0xFF000000)
                      : null,
                  textColor: widget.config.content.issuesPage.issueSections[i].textColor != null
                      ? Color(int.parse(widget.config.content.issuesPage.issueSections[i].textColor!.substring(1, 7), radix: 16) + 0xFF000000)
                      : null,
                  imageLeft: i % 2 == 0,
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
