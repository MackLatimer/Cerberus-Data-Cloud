import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/src/widgets/dynamic_size_app_bar.dart';
import 'package:universal_campaign_frontend/src/widgets/common_app_bar.dart';
import 'package:universal_campaign_frontend/src/widgets/footer.dart';
import 'package:universal_campaign_frontend/src/models/campaign_config.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final CampaignConfig config;
  const PrivacyPolicyPage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      double appBarHeight;

      if (width > 1000) {
        appBarHeight = 206;
      } else if (width > 600) {
        appBarHeight = 266;
      } else {
        appBarHeight = 306;
      }
      return Scaffold(
        appBar: DynamicSizeAppBar(
          height: appBarHeight,
          child: CommonAppBar(
            title: config.content.privacyPolicyPage.appBarTitle,
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        config.content.privacyPolicyPage.title,
                        style: textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        config.content.privacyPolicyPage.content,
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Footer(config: config),
        ],
      ),
      );
    });
  }
}
