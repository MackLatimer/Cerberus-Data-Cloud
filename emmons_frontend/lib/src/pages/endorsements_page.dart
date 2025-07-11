import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_button.dart';

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
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Endorse Curtis Emmons',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Show your support for Curtis Emmons by providing your endorsement. Your voice matters in this campaign! If you allow, we would be honored to publish your endorsement.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const SignupFormWidget(), // The form already contains the endorsement checkbox
                const SizedBox(height: 40),
                Center(child: const DonateButtonWidget()),
                const SizedBox(height: 40),
                // Placeholder for displaying endorsements later
                Text(
                  '--- List of Endorsements Coming Soon ---',
                   style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
                   textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
