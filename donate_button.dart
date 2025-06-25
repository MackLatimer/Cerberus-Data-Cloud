import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DonateButtonWidget extends StatelessWidget {
  const DonateButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.go('/donate');
      },
      // Style can be further customized here or rely on the global ElevatedButtonTheme
      child: const Text('Donate Now'),
    );
  }
}
