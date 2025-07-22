import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_project/widgets/join_list_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // What we do section
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What we do',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0), // Increased spacing
                const Text(
                  "From political campaigns, to non profit fundraising campaigns, to business advertising campaigns, we know how to multiply your reach. We find people and organizations that are improving people's lives and expand their reach and capacity. Between the three owners, we have dozens of years of experience running political campaigns, fundraising, serving on non profit boards, and running businesses. Our community needs a professional organization to keep up with the growth happening all around us so we are stepping up.",
                ),
                const SizedBox(height: 16.0), // Consistent spacing before button
                ElevatedButton(
                  onPressed: () {
                    context.go('/about');
                  },
                  child: const Text('Learn More'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),

          // Contact Us section
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Contact Us',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16.0), // Increased spacing
                const Text(
                  "We believe that your time is precious and we are most effective when we can react to problems quickly. That's why when you work with us, you will be in direct contact with one of the three owners. Prospective partners can also reach out to our direct lines to schedule a meeting with us. Communication is key in pulling of a successful campaign and we are dedicated to quick and transparent communication.",
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16.0), // Consistent spacing before button
                ElevatedButton(
                  onPressed: () {
                    context.go('/contact');
                  },
                  child: const Text('Learn More'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),

          // JOIN OUR EMAIL AND TEXT LIST section
            const JoinListSection(),
        ],
      ),
    );
  }
}
