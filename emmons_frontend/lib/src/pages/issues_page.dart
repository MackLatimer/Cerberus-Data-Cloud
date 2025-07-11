import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_button.dart';

class IssuesPage extends StatefulWidget {
  const IssuesPage({super.key});

  @override
  _IssuesPageState createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  Widget _buildIssueSection(BuildContext context, String title, String content, {Color imagePlaceholderColor = Colors.blueGrey}) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme; // Not used directly here yet, but good to have

    return Card(
      elevation: 2, // Subtle shadow
      margin: const EdgeInsets.symmetric(vertical: 12.0), // Space between cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Placeholder for an image
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: imagePlaceholderColor,
                borderRadius: BorderRadius.circular(8), // Rounded corners for the image container
              ),
              child: Center(
                child: Icon(Icons.image, size: 60, color: Colors.white.withOpacity(0.7)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Issues', // Changed title
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
                  'Hero Image: Issues', // Placeholder text
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
                        'Key Issues Facing Bell County Precinct 4',
                        style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildIssueSection(
                  context,
                  'Economic Growth & Job Creation',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Curtis believes in fostering a business-friendly environment that attracts new opportunities and supports local entrepreneurs.',
                  imagePlaceholderColor: Colors.teal,
                ),
                _buildIssueSection(
                  context,
                  'Community Safety & Emergency Services',
                  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ensuring our neighborhoods are safe and our first responders are well-equipped is a top priority.',
                  imagePlaceholderColor: Colors.orange,
                ),
                _buildIssueSection(
                  context,
                  'Infrastructure Development & Maintenance',
                  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. We must invest in maintaining and improving our roads, bridges, and public utilities to support our growing community.',
                  imagePlaceholderColor: Colors.indigo,
                ),
                _buildIssueSection(
                  context,
                  'Fiscal Responsibility & Transparent Governance',
                  'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Curtis is committed to responsible spending of taxpayer dollars and ensuring all county operations are transparent and accountable to the public.',
                  imagePlaceholderColor: Colors.brown,
                ),
                const SizedBox(height: 20),
                const SignupFormWidget(),
                const SizedBox(height: 40),
                Center(child: const DonateButtonWidget()),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
            ),
          ),
        ],
      ),
    );
  }
}
