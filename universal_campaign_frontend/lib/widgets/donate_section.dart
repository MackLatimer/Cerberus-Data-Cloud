import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_campaign_frontend/src/utils/breakpoint.dart';
import 'package:universal_campaign_frontend/src/models/campaign_config.dart';

class DonateSection extends StatelessWidget {
  final CampaignConfig config;
  const DonateSection({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;

    final children = [
      Text(
        config.content.donateSection.title,
        style: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: isCompact ? 20 : 0, width: isCompact ? 0 : 40),
      ElevatedButton(
        onPressed: () => context.go('/donate'),
        child: Text(config.content.donateSection.buttonText),
      ),
    ];

    return Container(
      color: colorScheme.primary,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: isCompact
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: children[0]),
                children[1], // SizedBox
                Expanded(flex: 1, child: children[2]),
              ],
            ),
    );
  }
}
