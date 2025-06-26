import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_project/widgets/join_list_section.dart'; // Import the shared widget

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Non Profit Fundraising Campaigns section
          Text(
            'Non Profit Fundraising Campaigns',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0), // Increased spacing
          const Text(
            "Non profits range from world changing organizations to schemes to turn donations into salaries. Unfortunately, the latter is usually the organization that is better at fundraising. We offer both fundraising and public relations campaigns for those organizations that are really making a difference on the ground. That allows these organizations to focus on serving the people of this community rather than being consumed by asking for money.",
          ),
          const SizedBox(height: 16.0), // Increased spacing
          ElevatedButton(
            onPressed: () {
              context.go('/contact');
            },
            child: const Text('Contact Us'),
          ),
          const SizedBox(height: 24.0),

          // Business Advertising Campaigns section
          Text(
            'Business Advertising Campaigns',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0), // Increased spacing
          const Text(
            "As whole hearted believers in the free market, we recognize that business is the back bone of our community. From providing vital services, to creating good jobs, to supporting our local non profits, none of us we be here without them. That's why we find mission driven businesses who are dedicated to making our community better and providing superior goods and services. We take care of advertising campaigns and customers acquisition allowing them to take care of business.",
          ),
          const SizedBox(height: 16.0), // Increased spacing
          ElevatedButton(
            onPressed: () {
              context.go('/contact');
            },
            child: const Text('Contact Us'),
          ),
          const SizedBox(height: 24.0),

          // Political Campaigns section
          Text(
            'Political Campaigns',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0), // Increased spacing
          const Text(
            "Our county is growing and we need to adapt to that growth. Government is known for being static and adapting too late. That's where we come in. We look for competent, conservative individuals who work at the speed of business. We provide them with a full service campaign structure, so they can focus on the task of creating a more efficient, effective, and smaller government. We serve the people who serve us.",
          ),
          const SizedBox(height: 16.0), // Increased spacing
          ElevatedButton(
            onPressed: () {
              context.go('/contact');
            },
            child: const Text('Contact Us'),
          ),
          const SizedBox(height: 24.0),

          // JOIN OUR EMAIL AND TEXT LIST section (using the shared widget)
          const JoinListSection(),
          const SizedBox(height: 24.0), // Optional: Add spacing after the section
        ],
      ),
    );
  }
}
