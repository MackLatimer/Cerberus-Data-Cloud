import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Container(
        color: colorScheme.primary, // Or another suitable color from your theme
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Paid for by Elect Emmons',
              style: textTheme.bodyMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Example of adding a privacy policy link to the footer as well,
            // if desired in addition to the one in the contact form.
            // TextButton(
            //   onPressed: () {
            //     // Ensure the privacy policy route is defined in your GoRouter setup
            //     context.go('/privacy-policy');
            //   },
            //   child: Text(
            //     'Privacy Policy',
            //     style: textTheme.bodySmall?.copyWith(
            //       color: Colors.white.withOpacity(0.7),
            //       decoration: TextDecoration.underline,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
