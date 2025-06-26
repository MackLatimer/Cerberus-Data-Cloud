import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_button.dart';

class IssuesPage extends StatelessWidget {
  const IssuesPage({super.key});

  Widget _buildIssueSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Key Issues'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
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
                ),
                _buildIssueSection(
                  context,
                  'Community Safety & Emergency Services',
                  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ensuring our neighborhoods are safe and our first responders are well-equipped is a top priority.',
                ),
                _buildIssueSection(
                  context,
                  'Infrastructure Development & Maintenance',
                  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. We must invest in maintaining and improving our roads, bridges, and public utilities to support our growing community.',
                ),
                _buildIssueSection(
                  context,
                  'Fiscal Responsibility & Transparent Governance',
                  'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Curtis is committed to responsible spending of taxpayer dollars and ensuring all county operations are transparent and accountable to the public.',
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
    );
  }
}
