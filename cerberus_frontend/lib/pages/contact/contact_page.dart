import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // Consider logging this error or showing a snackbar
      // print('Could not launch $url');
    }
  }

  Widget _buildContactDetailRow(BuildContext context, String label, String value, String urlScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          InkWell(
            child: Text(
              value,
              style: TextStyle(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline),
            ),
            onTap: () => _launchUrl('$urlScheme$value'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, String name, String phone, String email) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12.0), // Increased spacing
            _buildContactDetailRow(context, 'Phone', phone, 'tel:'),
            _buildContactDetailRow(context, 'Email', email, 'mailto:'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Contact Us',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0),
          _buildContactCard(
            context,
            'Michael Smith',
            '(512) 767-4324',
            'Michael@CerberusCampaigns.com',
          ),
          _buildContactCard(
            context,
            'Tyler Rayner',
            '(512) 767-4324', // Assuming same placeholder number, replace if different
            'Tyler@CerberusCampaigns.com',
          ),
          _buildContactCard(
            context,
            'Mack Latimer',
            '(512) 767-4324', // Assuming same placeholder number, replace if different
            'Mack@CerberusCampaigns.com',
          ),
        ],
      ),
    );
  }
}
