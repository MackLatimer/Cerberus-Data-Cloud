import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/models/campaign_config.dart';

class Footer extends StatelessWidget {
  final CampaignConfig config;
  const Footer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Container(
        color: colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              config.content.footer.paidForText,
              style: textTheme.bodyMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
