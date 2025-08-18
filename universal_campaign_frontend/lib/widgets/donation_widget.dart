import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add url_launcher

class DonationWidget extends StatefulWidget {
  final String stripePublicKey;
  final String apiBaseUrl;

  const DonationWidget({
    super.key,
    required this.stripePublicKey,
    required this.apiBaseUrl,
  });

  @override
  DonationWidgetState createState() => DonationWidgetState();
}

class DonationWidgetState extends State<DonationWidget> {
  // Removed PaymentIntent and related Stripe logic as we are using a direct link
  // PaymentIntent? _paymentIntent;

  @override
  void initState() {
    super.initState();
    // Removed Stripe.publishableKey initialization as it's not needed for direct link
    // Stripe.publishableKey = widget.stripePublicKey;
    // Removed _createPaymentIntent() as it's not needed for direct link
    // _createPaymentIntent();
  }

  // Removed _createPaymentIntent and _confirmPayment methods

  @override
  Widget build(BuildContext context) {
    // Removed _paymentIntent check as it's not needed for direct link
    // if (_paymentIntent == null) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Removed PaymentElement
          // PaymentElement(
          //   clientSecret: _paymentIntent!.clientSecret,
          // ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final Uri url = Uri.parse('https://buy.stripe.com/eVqeVfgG53lJ2AoafEgMw00');
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
            },
            child: const Text('Donate Now'),
          ),
        ],
      ),
    );
  }
}