Here is a complete, well-documented Flutter widget (donation_widget.dart) that uses Stripe for a multi-step donation process as you've described.

This code requires the flutter_stripe and http packages. Add them to your pubspec.yaml file:

YAML

dependencies:
  flutter:
    sdk: flutter
  flutter_stripe: ^10.1.1 # Use the latest version
  http: ^1.2.1 # Use the latest version
You will also need to initialize Stripe in your main.dart file with your publishable key.

Dart

// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'donation_widget.dart'; // Import the new widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set your Stripe publishable key
  Stripe.publishableKey = 'pk_test_YOUR_PUBLISHABLE_KEY'; // Replace with your key
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Donation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Make a Donation'),
        ),
        body: const DonationWidget(),
      ),
    );
  }
}
Donation Widget Code
Here is the code for donation_widget.dart. It is a self-contained, stateful widget that manages the three distinct steps of the donation process.

donation_widget.dart

Dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class DonationWidget extends StatefulWidget {
  const DonationWidget({super.key});

  @override
  State<DonationWidget> createState() => _DonationWidgetState();
}

class _DonationWidgetState extends State<DonationWidget> {
  // State Management
  int _currentStep = 1;
  int? _selectedChipIndex;
  final _customAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Step 1 State
  final List<double> _donationAmounts = [10, 25, 50, 100, 250, 500, 1000, 2500, 5000];
  double? _selectedAmount;

  // Step 2 State (Controllers for Autofill)
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _employerController = TextEditingController();
  final _occupationController = TextEditingController();

  // Step 3 State
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _endorseChecked = false;
  bool _getInvolvedChecked = false;
  bool _getTextsChecked = false;
  bool _getEmailsChecked = false;

  @override
  void initState() {
    super.initState();
    _customAmountController.addListener(() {
      if (_customAmountController.text.isNotEmpty) {
        setState(() {
          _selectedChipIndex = null; // Deselect chips
          try {
            _selectedAmount = double.parse(_customAmountController.text);
          } catch (e) {
            _selectedAmount = null; // Invalid number
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _customAmountController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _employerController.dispose();
    _occupationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Main build method that switches between steps
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(),
        ),
      ),
    );
  }

  /// Returns the widget for the currently active step
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildAmountSelectionStep();
      case 2:
        return _buildUserInfoAndPaymentStep();
      case 3:
        return _buildConfirmationStep();
      default:
        return const Center(child: Text("An error occurred."));
    }
  }

  //****************************************************************************
  // STEP 1: Amount Selection
  //****************************************************************************
  Widget _buildAmountSelectionStep() {
    return Column(
      key: const ValueKey<int>(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose an amount', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(_donationAmounts.length, (index) {
            return ChoiceChip(
              label: Text('\$${_donationAmounts[index].toInt()}'),
              selected: _selectedChipIndex == index,
              onSelected: (selected) {
                setState(() {
                  _selectedChipIndex = selected ? index : null;
                  _selectedAmount = selected ? _donationAmounts[index] : null;
                  _customAmountController.clear();
                  FocusScope.of(context).unfocus(); // Hide keyboard
                });
              },
            );
          }),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _customAmountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
          decoration: const InputDecoration(
            labelText: 'Or enter a custom amount',
            prefixIcon: Icon(Icons.attach_money),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_selectedAmount ?? 0) >= 1.00
                ? () => setState(() => _currentStep = 2)
                : null,
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  //****************************************************************************
  // STEP 2: User Information & Payment
  //****************************************************************************
  Widget _buildUserInfoAndPaymentStep() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey<int>(2),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Donating: \$${_selectedAmount?.toStringAsFixed(2) ?? '0.00'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextButton.icon(
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Change Amount'),
            onPressed: () => setState(() => _currentStep = 1),
          ),
          const Divider(height: 32),
          const Text('Your Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          AutofillGroup(
            child: Column(
              children: [
                _buildTextFormField(_firstNameController, 'First Name', [AutofillHints.givenName]),
                _buildTextFormField(_lastNameController, 'Last Name', [AutofillHints.familyName]),
                _buildTextFormField(_address1Controller, 'Address line 1', [AutofillHints.streetAddressLine1]),
                _buildTextFormField(_address2Controller, 'Address line 2 (Optional)', [AutofillHints.streetAddressLine2], isRequired: false),
                _buildTextFormField(_cityController, 'City', [AutofillHints.addressCity]),
                Row(
                  children: [
                    Expanded(child: _buildTextFormField(_stateController, 'State', [AutofillHints.addressState])),
                    const SizedBox(width: 8),
                    Expanded(child: _buildTextFormField(_zipController, 'ZIP Code', [AutofillHints.postalCode], keyboardType: TextInputType.number)),
                  ],
                ),
                _buildTextFormField(_employerController, 'Employer', [AutofillHints.organizationName]),
                _buildTextFormField(_occupationController, 'Occupation', [AutofillHints.jobTitle]),
              ],
            ),
          ),
          const Divider(height: 32),
          const Text('Payment Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // This is the pre-built Stripe CardForm element.
          CardFormField(
            controller: CardFormEditController(),
            style: CardFormStyle(
              backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handlePayment,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Donation'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, Iterable<String> autofillHints, {bool isRequired = true, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        autofillHints: autofillHints,
        keyboardType: keyboardType,
        validator: isRequired ? (value) => (value == null || value.isEmpty) ? 'This field is required' : null : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  //****************************************************************************
  // STEP 3: Post-Donation Confirmation
  //****************************************************************************
  Widget _buildConfirmationStep() {
    return Column(
      key: const ValueKey<int>(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Thank You!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 8),
        Text('Your generous donation of \$${_selectedAmount?.toStringAsFixed(2) ?? '0.00'} has been processed.', style: const TextStyle(fontSize: 16)),
        const Divider(height: 32),
        const Text('Stay Connected', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildTextFormField(_emailController, 'Email Address', [AutofillHints.email], keyboardType: TextInputType.emailAddress),
        _buildTextFormField(_phoneController, 'Phone Number', [AutofillHints.telephoneNumber], keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildCheckboxTile(title: 'Endorse', value: _endorseChecked, onChanged: (val) => setState(() => _endorseChecked = val!)),
        _buildCheckboxTile(title: 'Get Involved', value: _getInvolvedChecked, onChanged: (val) => setState(() => _getInvolvedChecked = val!)),
        _buildCheckboxTile(title: 'Get Texts', value: _getTextsChecked, onChanged: (val) => setState(() => _getTextsChecked = val!)),
        _buildCheckboxTile(title: 'Get Emails', value: _getEmailsChecked, onChanged: (val) => setState(() => _getEmailsChecked = val!)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Here you would send the collected contact info and preferences
              // to your backend, CRM, or mailing list service.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for connecting!')),
              );
            },
            child: const Text('Finish'),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxTile({required String title, required bool value, required ValueChanged<bool?> onChanged}) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  //****************************************************************************
  // Stripe Payment Logic
  //****************************************************************************

  Future<void> _handlePayment() async {
    // 1. Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Create Payment Intent on your server
      final paymentIntentData = await _createPaymentIntent(
        amount: (_selectedAmount! * 100).toInt(), // Amount in cents
        currency: 'usd',
      );

      final clientSecret = paymentIntentData['clientSecret'];

      // 3. Collect billing details from the form
      final billingDetails = BillingDetails(
        name: '${_firstNameController.text} ${_lastNameController.text}',
        email: _emailController.text, // You might collect this earlier
        phone: _phoneController.text, // Or this
        address: Address(
          line1: _address1Controller.text,
          line2: _address2Controller.text,
          city: _cityController.text,
          state: _stateController.text,
          postalCode: _zipController.text,
          country: 'US',
        ),
      );

      // 4. Confirm the payment on the client
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );

      // 5. Payment successful, move to the next step
      setState(() {
        _currentStep = 3;
      });

    } on StripeException catch (e) {
      // Handle Stripe-specific errors (e.g., card declined)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.error.localizedMessage}')),
      );
    } catch (e) {
      // Handle other errors (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// ⚠️ SERVER-SIDE FUNCTION (Placeholder) ⚠️
  /// This function simulates a call to your backend server.
  /// In a real app, this would be an HTTPS request to an endpoint you control.
  Future<Map<String, dynamic>> _createPaymentIntent({required int amount, required String currency}) async {
    // DO NOT store your secret key in the app!
    // This is a placeholder and is NOT secure.
    const String stripeSecretKey = 'sk_test_YOUR_SECRET_KEY'; // Replace with your test secret key
    const String url = 'https://api.stripe.com/v1/payment_intents';

    final body = {
      'amount': amount.toString(),
      'currency': currency,
      'payment_method_types[]': 'card',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create PaymentIntent: ${response.body}');
      }
    } catch (err) {
      throw Exception('Failed to connect to Stripe: $err');
    }
  }
}