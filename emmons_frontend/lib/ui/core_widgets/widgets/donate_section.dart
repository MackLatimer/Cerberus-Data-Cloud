import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emmons_frontend/main.dart'; // For campaignProvider
import 'package:emmons_frontend/core/utils/breakpoint.dart';

class DonateSection extends ConsumerWidget {
  const DonateSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignConfig = ref.watch(campaignProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;

    final children = [
      Text(
        campaignConfig.content.donateSectionTitle,
        style: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: isCompact ? 20 : 0, width: isCompact ? 0 : 40),
      ElevatedButton(
        onPressed: () => context.go('/donate'),
        child: Text(campaignConfig.content.callToActionLabel),
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
