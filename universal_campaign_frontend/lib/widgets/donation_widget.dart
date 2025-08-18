/* import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

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
  PaymentIntent? _paymentIntent;

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = widget.stripePublicKey;
    _createPaymentIntent();
  }

  Future<void> _createPaymentIntent() async {
    final url = Uri.parse('${widget.apiBaseUrl}/create-payment-intent');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': 1000, // Example amount in cents (e.g., 10.00 USD)
          'currency': 'usd',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _paymentIntent = PaymentIntent.fromJson(data);
        });
      } else {
        // print('Failed to create PaymentIntent: ${response.body}');
        // Handle error appropriately
      }
    } catch (e) {
      // print('Error creating PaymentIntent: $e');
      // Handle error appropriately
    }
  }

  Future<void> _confirmPayment() async {
    if (_paymentIntent == null) {
      // print('PaymentIntent or client secret is null.');
      return;
    }

    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: _paymentIntent!.clientSecret,
          merchantDisplayName: 'Cerberus Data Cloud',
          // You can add other parameters like customerId, customerEphemeralKey, etc.
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      // print('Payment successful!');
      // Handle successful payment (e.g., show success message, navigate)
    } on StripeException catch (_) { // Use _ to indicate unused variable
      // print('Error during payment: ${e.error.code} - ${e.error.message}');
      // Handle payment error (e.g., show error message)
    } catch (_) { // Use _ to indicate unused variable
      // print('An unexpected error occurred: $e');
      // Handle unexpected errors
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_paymentIntent == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaymentElement(
            clientSecret: _paymentIntent!.clientSecret,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _confirmPayment,
            child: const Text('Donate Now'),
          ),
        ],
      ),
    );
  }
}*/
