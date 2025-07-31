import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:candidate_website/src/widgets/donation_widget.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Our new website is coming soon!',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'In the meantime, you can support our campaign by donating below.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: const DonationWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: () => context.go('/home'),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
