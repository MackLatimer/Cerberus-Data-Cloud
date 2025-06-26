import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // What we do section
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
          const SizedBox(height: 24.0),

          // JOIN OUR EMAIL AND TEXT LIST section
          Text(
            'JOIN OUR EMAIL AND TEXT LIST',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0),
          const TextField(
            decoration: InputDecoration(
              labelText: 'First name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Last name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '*By including your email, you agree to be a part of our email list.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16.0),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '*By including your phone number, you agree to be a part of our text list.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement submit functionality
            },
            child: const Text('Submit'),
          ),
          const SizedBox(height: 24.0),

          // Contact Us section
          Text(
            'Contact Us',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0), // Increased spacing
          const Text(
            "We believe that your time is precious and we are most effective when we can react to problems quickly. That's why when you work with us, you will be in direct contact with one of the three owners. Prospective partners can also reach out to our direct lines to schedule a meeting with us. Communication is key in pulling of a successful campaign and we are dedicated to quick and transparent communication.",
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
    );
  }
}
