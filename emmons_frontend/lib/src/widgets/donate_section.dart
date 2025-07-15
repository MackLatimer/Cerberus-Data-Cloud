import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/donate_button.dart';

class DonateSection extends StatelessWidget {
  const DonateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surfaceVariant,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Make a Difference!',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
          const Expanded(
            flex: 1,
            child: DonateButtonWidget(),
          ),
        ],
      ),
    );
  }
}
