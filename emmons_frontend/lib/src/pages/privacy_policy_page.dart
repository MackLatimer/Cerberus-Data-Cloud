import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/dynamic_size_app_bar.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/footer.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      double appBarHeight;

      // extended
      if (width > 1000) {
        appBarHeight = 206;
        // medium
      } else if (width > 600) {
        appBarHeight = 266;
        // compact
      } else {
        appBarHeight = 306;
      }
      return Scaffold(
        appBar: DynamicSizeAppBar(
          height: appBarHeight,
          child: CommonAppBar(
            title: 'Privacy Policy', // No scroll controller needed for a static page
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
                        'Privacy Policy',
                        style: textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No mobile information will be shared by us with third parties/affiliates for marketing/promotional purposes. Text messaging originator opt-in data and consent will not be shared with any third parties unless required by law. Carriers are not liable for delayed or undelivered messages.',
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
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}
