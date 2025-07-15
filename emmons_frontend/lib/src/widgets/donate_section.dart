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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Support the Campaign and Help Us Make a Difference!',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 40),
            const DonateButtonWidget(),
          ],
        ),
      ),
    );
  }
}
