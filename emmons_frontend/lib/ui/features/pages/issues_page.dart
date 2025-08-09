import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emmons_frontend/main.dart'; // For campaignProvider
import 'package:emmons_frontend/models/issue.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/dynamic_size_app_bar.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/common_app_bar.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/signup_form.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/donate_section.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/footer.dart';
import 'package:emmons_frontend/core/utils/breakpoint.dart';

class IssuesPage extends ConsumerStatefulWidget {
  const IssuesPage({super.key});

  @override
  IssuesPageState createState() => IssuesPageState();
}

class IssuesPageState extends ConsumerState<IssuesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildIssueSection(
    BuildContext context, {
    required Issue issue,
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
          image: AssetImage(issue.imageUrl),
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
            issue.title,
            style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold, color: textColor ?? Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            issue.description,
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
            title: campaignConfig.content.issuesPageTitle,
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
                    image: AssetImage(campaignConfig.content.issuesPageHeroImagePath),
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
                campaignConfig.content.issuesPageTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ...campaignConfig.issues.asMap().entries.map((entry) {
                int idx = entry.key;
                Issue issue = entry.value;
                return _buildIssueSection(
                  context,
                  issue: issue,
                  imageLeft: idx % 2 == 0, // Alternate image left/right
                  backgroundColor: idx % 2 == 0 ? campaignConfig.theme.primaryColor : null,
                  textColor: idx % 2 == 0 ? Colors.white : null,
                );
              }),
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
