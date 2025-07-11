import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_button.dart';
import 'package:candidate_website/src/widgets/high_profile_endorsement_card.dart'; // Import the new widget

class EndorsementsPage extends StatefulWidget {
  const EndorsementsPage({super.key});

  @override
  _EndorsementsPageState createState() => _EndorsementsPageState();
}

class _EndorsementsPageState extends State<EndorsementsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Endorsements',
        scrollController: _scrollController,
      ),
      body: CustomScrollView( // Changed to CustomScrollView
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 300, // Height of the hero image
              color: Colors.grey[300], // Placeholder color
              child: Center(
                child: Text(
                  'Hero Image: Endorsements', // Placeholder text
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Endorsements', // Changed title to be more direct
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // High-Profile Endorsements Section
                      Text(
                        'Distinguished Supporters',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const HighProfileEndorsementCard(
                        name: 'Jane Doe',
                        quote: 'Curtis has the vision and dedication Bell County needs. He has my full support!',
                        imagePath: 'assets/placeholder_jane.png', // Placeholder
                        imageBackgroundColor: Colors.purpleAccent,
                      ),
                      const HighProfileEndorsementCard(
                        name: 'John Smith',
                        quote: 'I\'ve worked with Curtis for years, and his commitment to our community is unwavering.',
                        imagePath: 'assets/placeholder_john.png', // Placeholder
                        imageBackgroundColor: Colors.lightBlueAccent,
                      ),
                      const SizedBox(height: 40),

                      // List of Other Endorsements Section
                      Text(
                        'Community Endorsers',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      _buildEndorserList(context, [
                        'Michael Brown', 'Emily Davis', 'David Wilson', 'Sarah Miller',
                        'Robert Garcia', 'Linda Rodriguez', 'James Martinez', 'Patricia Hernandez',
                        'Christopher Lee', 'Jessica Gonzalez', 'Daniel Walker', 'Karen Hall',
                        // Add more placeholder names as needed
                      ]),
                      const SizedBox(height: 40),

                      // Call to action to endorse (original form)
                      Text(
                        'Add Your Voice!',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Show your support for Curtis Emmons by providing your endorsement. Your voice matters!',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const SignupFormWidget(), // The form already contains the endorsement checkbox
                      const SizedBox(height: 40),
                      Center(child: const DonateButtonWidget()),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndorserList(BuildContext context, List<String> endorsers) {
    final textTheme = Theme.of(context).textTheme;
    if (endorsers.isEmpty) {
      return Text(
        'More endorsements coming soon!',
        style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      );
    }

    return Wrap(
      spacing: 8.0, // Horizontal space between chips
      runSpacing: 4.0, // Vertical space between lines of chips
      alignment: WrapAlignment.center,
      children: endorsers.map((name) {
        // Simplified Chip for debugging
        return Chip(label: Text(name));
      }).toList(),
    );
  }
}
