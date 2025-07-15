import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_section.dart';
import 'package:candidate_website/src/widgets/high_profile_endorsement_card.dart';
import 'package:candidate_website/src/widgets/footer.dart';

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
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: 'Endorsements',
        scrollController: _scrollController,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'Hero Image: Endorsements',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 40),
                Text(
                  'Endorsements',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  'Distinguished Supporters',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const HighProfileEndorsementCard(
                  name: 'Jane Doe',
                  quote:
                      'Curtis has the vision and dedication Bell County needs. He has my full support!',
                  imagePath: 'assets/placeholder_jane.png',
                  imageBackgroundColor: Colors.purpleAccent,
                  imageLeft: true,
                ),
                const HighProfileEndorsementCard(
                  name: 'John Smith',
                  quote:
                      'I\'ve worked with Curtis for years, and his commitment to our community is unwavering.',
                  imagePath: 'assets/placeholder_john.png',
                  imageBackgroundColor: Colors.lightBlueAccent,
                  imageLeft: false,
                ),
                const HighProfileEndorsementCard(
                  name: 'Bob Johnson',
                  quote: 'A true leader for our time.',
                  imagePath: 'assets/placeholder_bob.png',
                  imageBackgroundColor: Colors.greenAccent,
                  imageLeft: true,
                ),
                const HighProfileEndorsementCard(
                  name: 'Susan Williams',
                  quote: 'The best choice for Bell County.',
                  imagePath: 'assets/placeholder_susan.png',
                  imageBackgroundColor: Colors.redAccent,
                  imageLeft: false,
                ),
                const HighProfileEndorsementCard(
                  name: 'Michael Brown',
                  quote: 'He will get the job done.',
                  imagePath: 'assets/placeholder_michael.png',
                  imageBackgroundColor: Colors.orangeAccent,
                  imageLeft: true,
                ),
                const SizedBox(height: 40),
                Text(
                  'Community Endorsers',
                  style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildEndorserList(context, [
                      'Michael Brown',
                      'Emily Davis',
                      'David Wilson',
                      'Sarah Miller',
                      'Robert Garcia',
                      'Linda Rodriguez',
                      'James Martinez',
                      'Patricia Hernandez',
                      'Christopher Lee',
                      'Jessica Gonzalez',
                      'Daniel Walker',
                      'Karen Hall',
                    ]),
                    const SizedBox(height: 40),
                    Text(
                      'Add Your Voice!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Show your support for Curtis Emmons by providing your endorsement. Your voice matters!',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const DonateSection(),
                    const SizedBox(height: 40),
                    const SignupFormWidget(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
          const SliverToBoxAdapter(child: Footer()),
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
      spacing: 8.0,
      runSpacing: 4.0,
      alignment: WrapAlignment.center,
      children: endorsers.map((name) {
        return Chip(label: Text(name));
      }).toList(),
    );
  }
}
