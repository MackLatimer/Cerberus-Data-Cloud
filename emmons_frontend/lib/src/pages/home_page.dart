import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_button.dart';
import 'package:candidate_website/src/widgets/home_page_section.dart'; // Import the new widget
import 'package:candidate_website/src/widgets/footer.dart'; // Import the Footer widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: 'Curtis Emmons for Bell County Precinct 4',
        scrollController: _scrollController,
      ),
      body: CustomScrollView( // Changed to CustomScrollView for more flexibility with slivers
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 300, // Height of the hero image
              color: Colors.grey[300], // Placeholder color
              child: Center(
                child: Text(
                  'Hero Image Placeholder',
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
                  constraints: const BoxConstraints(maxWidth: 800), // Max width for main content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Welcome to the Campaign!',
                        style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Join us in making a difference for Bell County Precinct 4. Curtis Emmons is dedicated to serving our community with integrity, transparency, and a commitment to progress.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // SignupFormWidget was here
                Center(child: const DonateButtonWidget()), // Donate button can stay or move with form
                const SizedBox(height: 60), // Increased spacing before sections

                // Page Sections
                const HomePageSection(
                  title: 'Issues',
                  summary: 'Learn about the key issues Curtis is focused on to improve our precinct.',
                  imagePath: 'assets/placeholder_issues.png', // Replace with actual image path
                  routePath: '/issues',
                  imageBackgroundColor: Colors.blueGrey,
                ),
                const HomePageSection(
                  title: 'About Me',
                  summary: 'Discover more about Curtis Emmons, his background, and his vision for Bell County.',
                  imagePath: 'assets/placeholder_about.png', // Replace with actual image path
                  routePath: '/about',
                  imageBackgroundColor: Colors.teal,
                ),
                const HomePageSection(
                  title: 'Endorsements',
                  summary: 'See who is endorsing Curtis and learn how you can add your support.',
                  imagePath: 'assets/placeholder_endorsements.png', // Replace with actual image path
                  routePath: '/endorsements',
                  imageBackgroundColor: Colors.amber,
                ),
                const HomePageSection(
                  title: 'Donate',
                  summary: 'Support the campaign financially and help us make a difference.',
                  imagePath: 'assets/placeholder_donate.png', // Replace with actual image path
                  routePath: '/donate',
                  imageBackgroundColor: Colors.green,
                ),
                const SizedBox(height: 40),
                const SignupFormWidget(), // Moved SignupFormWidget here
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
            ),
          ),
          const SliverToBoxAdapter(child: Footer()), // Add Footer here
        ],
      ),
    );
  }
}
