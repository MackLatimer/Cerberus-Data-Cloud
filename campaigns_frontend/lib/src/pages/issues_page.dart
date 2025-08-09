import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campaigns_frontend/src/widgets/dynamic_size_app_bar.dart';
import 'package:campaigns_frontend/src/widgets/common_app_bar.dart';
import 'package:campaigns_frontend/src/widgets/signup_form.dart';
import 'package:campaigns_frontend/src/widgets/donate_section.dart';
import 'package:campaigns_frontend/src/widgets/footer.dart';
import 'package:campaigns_frontend/src/utils/breakpoint.dart';
import 'package:campaigns_frontend/src/providers.dart';

class IssuesPage extends ConsumerWidget {
  const IssuesPage({super.key});

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
            title: config.issuesPageText.heroTitle,
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(config.issuesPageText.issues[0].imagePath),
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
                  config.issuesPageText.heroTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                for (var i = 0; i < config.numberOfIssues; i++)
                  _buildIssueSection(
                    context,
                    config.issuesPageText.issues[i].title,
                    config.issuesPageText.issues[i].content,
                    imagePath: config.issuesPageText.issues[i].imagePath,
                    backgroundColor: i % 2 == 0 ? config.primaryColor : config.secondaryColor,
                    textColor: Colors.white,
                    imageLeft: i % 2 == 0,
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
}
