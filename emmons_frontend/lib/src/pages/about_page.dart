import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_button.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
        title: 'About Me', // Changed title
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
                  'Hero Image: About Me', // Placeholder text
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
                        'About Curtis Emmons',
                        style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Placeholder for biography
                Text(
                  'Curtis Emmons is a dedicated member of our community with a passion for public service. [More biography details will be added here soon... e.g., background, experience, vision for the precinct].',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.justify, // Justify for longer text blocks
                ),
                const SizedBox(height: 40),
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
