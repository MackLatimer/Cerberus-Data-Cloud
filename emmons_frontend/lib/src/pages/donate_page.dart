import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/donate_button.dart'; // Re-using for consistency
// import 'package:url_launcher/url_launcher.dart'; // For actual donation link later

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Placeholder for actual donation link
  final String _donationUrl = 'https://placeholder-donation-platform.com/curtis-emmons';

  // Future<void> _launchDonationUrl() async {
  //   if (!await launchUrl(Uri.parse(_donationUrl))) {
  //     // TODO: Handle error - perhaps show a dialog or snackbar
  //     print('Could not launch $_donationUrl');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Support the Campaign',
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
                  'Hero Image: Donate', // Placeholder text
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
                  constraints: const BoxConstraints(maxWidth: 600), // Slightly narrower for focus
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Your Support Makes a Difference!',
                        style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Contributions to the Curtis Emmons for County Commissioner campaign help us reach voters, share our message, and work towards a better future for Bell County Precinct 4. Every donation, no matter the size, is deeply appreciated and crucial to our success.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'By clicking the button below, you will be redirected to our secure donation portal. (This is a placeholder - no actual transaction will occur).',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: double.infinity, // Make button wider
                    child: ElevatedButton(
                      onPressed: () {
                        // For now, just show a dialog or navigate internally if a specific donate UI is planned within app
                        // Later, this will use url_launcher: _launchDonationUrl();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Donation Placeholder'),
                            content: Text('This would navigate to: $_donationUrl'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                        textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 24), // Larger text for this button
                      ),
                      child: const Text('Donate Securely Now'),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'If you prefer to donate by mail, please send a check payable to "Curtis Emmons Campaign" to: [Campaign PO Box or Address Here - Placeholder]',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 20),
                 Text(
                  'Thank you for your generosity!',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
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
