import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_button.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'About Curtis Emmons'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
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
    );
  }
}
