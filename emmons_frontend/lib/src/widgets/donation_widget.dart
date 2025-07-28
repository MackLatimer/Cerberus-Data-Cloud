import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:candidate_website/src/config.dart';

class DonationWidget extends StatefulWidget {
  const DonationWidget({super.key});

  @override
  State<DonationWidget> createState() => _DonationWidgetState();
}

class _DonationWidgetState extends State<DonationWidget> {
  String? _selectedAmount;
  final TextEditingController _customAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _donationAmounts = [
    '10',
    '25',
    '50',
    '100',
    '250',
    '500',
    '1000',
    '2500',
    '5000',
  ];

  Future<void> _handleDonate() async {
    if (_selectedAmount == null && _customAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter a donation amount.')),
      );
      return;
    }

    final amount = _selectedAmount ?? _customAmountController.text;

    try {
      final response = await http.post(
        Uri.parse('https://campaigns-api-885603051818.us-south1.run.app/donate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'amount': amount}),
      );

      final responseData = json.decode(response.body);
      final clientSecret = responseData['clientSecret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Emmons Campaign',
          billingDetails: const BillingDetails(
            name: 'Test User', // Placeholder
          ),
          customFlow: true,
          allowsDelayedPaymentMethods: true,
          googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US', testEnv: true),
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // Handle post-payment flow
      _showPostDonationDialog();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showPostDonationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thank you for your donation!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Employer'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Occupation'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email Address'),
              ),
              CheckboxListTile(
                title: const Text('Sign up for email updates'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('I would like to volunteer'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('I would like a yard sign'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('I would like to host an event'),
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: _donationAmounts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final amount = _donationAmounts[index];
              final isSelected = _selectedAmount == amount;
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedAmount = amount;
                    _customAmountController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? const Color(0xFF002663) : const Color(0xFFA01124),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  '\$$amount',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _customAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Custom Amount',
              prefixText: '\$',
            ),
            onChanged: (value) {
              setState(() {
                _selectedAmount = null;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handleDonate,
            child: const Text('Donate'),
          ),
        ],
      ),
    );
  }
}
