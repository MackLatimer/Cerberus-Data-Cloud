import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:candidate_website/src/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

class DonationWidget extends StatefulWidget {
  const DonationWidget({super.key});

  @override
  State<DonationWidget> createState() => _DonationWidgetState();
}

class _DonationWidgetState extends State<DonationWidget> {
  int _currentStep = 0; // 0: amount, 1: donor/payment, 2: contact
  String? _selectedAmount;
  final TextEditingController _customAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _cardFormController = CardEditController();

  // Stripe related
  String? _paymentIntentClientSecret;
  String? _paymentIntentId;
  String? _customerId;

  // Donor details
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _employerController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  // Contact details
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _contactEmail = false;
  bool _contactPhone = false;
  bool _contactMail = false;
  bool _contactSms = false;

  // Checkboxes
  bool _coversFees = false;
  bool _isRecurring = false;

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

  @override
  void dispose() {
    _customAmountController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _employerController.dispose();
    _occupationController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _cardFormController.dispose();
    super.dispose();
  }

  Future<void> _createPaymentIntent() async {
    if (_selectedAmount == null && _customAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter a donation amount.')),
      );
      return;
    }

    final amount = _selectedAmount ?? _customAmountController.text;

    try {
      final response = await http.post(
        Uri.parse('https://campaigns-api-885603051818.us-south1.run.app/api/v1/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': amount,
          'is_recurring': _isRecurring,
          'covers_fees': _coversFees,
          'email': _emailController.text, // Pass email for customer creation if recurring
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _paymentIntentClientSecret = responseData['clientSecret'];
          _paymentIntentId = responseData['paymentIntentId'];
          _customerId = responseData['customerId'];
          _currentStep = 1; // Move to donor details and payment
        });
      } else {
        throw responseData['error'] ?? 'Failed to create payment intent.';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating payment intent: $e')),
        );
      }
    }
  }

  Future<void> _displayPaymentSheet() async {
    try {
      // 1. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: _paymentIntentClientSecret!,
          merchantDisplayName: 'Emmons for Office',
          customerId: _customerId,
          customerEphemeralKeySecret: null, // Not needed for web
          setupIntentClientSecret: _isRecurring ? _paymentIntentClientSecret : null, // Use PI client secret for SetupIntent if recurring
          style: Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
          billingDetails: BillingDetails(
            email: _emailController.text,
            phone: _phoneNumberController.text,
            address: Address(
              line1: _addressLine1Controller.text,
              line2: _addressLine2Controller.text,
              city: _cityController.text,
              state: _stateController.text,
              postalCode: _zipController.text,
              country: 'US',
            ),
          ),
        ),
      );

      // 2. Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // Payment successful, proceed to save details
      _saveDonorDetailsToBackend();
    } on StripeException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stripe Error: ${e.error.localizedMessage}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      }
    }
  }

  Future<void> _saveDonorDetailsToBackend() async {
    try {
      final response = await http.post(
        Uri.parse('https://campaigns-api-885603051818.us-south1.run.app/api/v1/update-donation-details'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'payment_intent_id': _paymentIntentId,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'address_line1': _addressLine1Controller.text,
          'address_line2': _addressLine2Controller.text,
          'address_city': _cityController.text,
          'address_state': _stateController.text,
          'address_zip': _zipController.text,
          'employer': _employerController.text,
          'occupation': _occupationController.text,
          'email': _emailController.text,
          'phone_number': _phoneNumberController.text,
          'is_recurring': _isRecurring,
          'covers_fees': _coversFees,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _currentStep = 2; // Move to contact details
        });
      } else {
        throw json.decode(response.body)['error'] ?? 'Failed to save donor details.';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving donor details: $e')),
        );
      }
    }
  }

  Future<void> _confirmPaymentAndSaveDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (kIsWeb) {
      // For web, payment is handled by PaymentSheet, which is triggered by _displayPaymentSheet
      // This method will now only save donor details after the payment sheet is successful.
      _saveDonorDetailsToBackend();
      return;
    }

    try {
      // For non-web, confirm payment directly
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: _paymentIntentClientSecret!,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
        options: const PaymentMethodOptions(
          setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
        ),
      );

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        _saveDonorDetailsToBackend();
      } else {
        throw 'Payment failed: ${paymentIntent.status}';
      }
    } on StripeException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stripe Error: ${e.error.localizedMessage}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing payment: $e')),
        );
      }
    }
  }

  Future<void> _saveContactDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://campaigns-api-885603051818.us-south1.run.app/api/v1/update-donation-details'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'payment_intent_id': _paymentIntentId,
          'email': _emailController.text,
          'phone_number': _phoneNumberController.text,
          'contact_email': _contactEmail,
          'contact_phone': _contactPhone,
          'contact_mail': _contactMail,
          'contact_sms': _contactSms,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          context.go('/post-donation-details'); // Navigate to success page
        }
      } else {
        throw json.decode(response.body)['error'] ?? 'Failed to save contact details.';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving contact details: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_currentStep == 0) ...[
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
              onPressed: _createPaymentIntent,
              child: const Text('Donate Now'),
            ),
          ] else if (_currentStep == 1) ...[
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _addressLine1Controller,
              decoration: const InputDecoration(labelText: 'Address Line 1'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _addressLine2Controller,
              decoration: const InputDecoration(labelText: 'Address Line 2 (Optional)'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: 'State'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _zipController,
              decoration: const InputDecoration(labelText: 'Zip Code'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _employerController,
              decoration: const InputDecoration(labelText: 'Employer'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _occupationController,
              decoration: const InputDecoration(labelText: 'Occupation'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            if (kIsWeb) // Conditionally render PaymentSheet for web
              ElevatedButton(
                onPressed: _displayPaymentSheet,
                child: const Text('Enter Payment Details'),
              )
            else
              CardField(
                controller: _cardFormController,
                onCardChanged: (card) {
                  // Handle card changes if needed
                },
              ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('Cover transaction fees?'),
              value: _coversFees,
              onChanged: (bool? value) {
                setState(() {
                  _coversFees = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Make this a recurring payment?'),
              value: _isRecurring,
              onChanged: (bool? value) {
                setState(() {
                  _isRecurring = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmPaymentAndSaveDetails,
              child: const Text('Submit Payment'),
            ),
          ] else if (_currentStep == 2) ...[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('Contact me via Email'),
              value: _contactEmail,
              onChanged: (bool? value) {
                setState(() {
                  _contactEmail = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Contact me via Phone'),
              value: _contactPhone,
              onChanged: (bool? value) {
                setState(() {
                  _contactPhone = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Contact me via Mail'),
              value: _contactMail,
              onChanged: (bool? value) {
                setState(() {
                  _contactMail = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Contact me via SMS'),
              value: _contactSms,
              onChanged: (bool? value) {
                setState(() {
                  _contactSms = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveContactDetails,
              child: const Text('Complete Donation'),
            ),
          ],
        ],
      ),
    );
  }
}