import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_campaign_frontend/providers/campaign_provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe_web/flutter_stripe_web.dart';

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
        return _buildUserInfoStep();
      case 3:
        return _buildConfirmationStep();
      default:
        return const Center(child: Text('An error occurred.'));
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
          alignment: WrapAlignment.center,
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
  // STEP 2: User Information
  //****************************************************************************
  Widget _buildUserInfoStep() {
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
                _buildTextFormField(_employerController, 'Employer', []),
                _buildTextFormField(_occupationController, 'Occupation', []),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _initiatePayment,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Proceed to Payment'),
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

  Future<void> _initiatePayment() async {
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
        // Pass billing details to the backend
        billingDetails: BillingDetails(
          name: '${_firstNameController.text} ${_lastNameController.text}',
          email: _emailController.text,
          phone: _phoneController.text,
          address: Address(
            line1: _address1Controller.text,
            line2: _address2Controller.text,
            city: _cityController.text,
            state: _stateController.text,
            postalCode: _zipController.text,
            country: 'US',
          ),
        ),
      );

      final clientSecret = paymentIntentData['clientSecret'];

      if (!mounted) return;

      // 3. Navigate to the Payment Screen
      final paymentResult = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => _StripePaymentScreen(
            clientSecret: clientSecret,
            amount: _selectedAmount!,
          ),
        ),
      );

      // 4. Check payment result and move to the next step
      if (paymentResult == true) {
        setState(() {
          _currentStep = 3;
        });
      }

    } catch (e) {
      if (!mounted) return;
      // Handle errors (e.g., network issues, failed to create PI)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Calls the backend to create a Stripe PaymentIntent.
  Future<Map<String, dynamic>> _createPaymentIntent({
    required int amount,
    required String currency,
    required BillingDetails billingDetails,
  }) async {
    final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
    final config = campaignProvider.campaignConfig;
    if (config == null) {
      throw Exception('Campaign configuration is not loaded.');
    }

    final url = Uri.parse('${config.apiBaseUrl}/donate/create-payment-intent');

    final body = json.encode({
      'amount': amount,
      'currency': currency,
      'campaign_id': config.campaignId,
      // The backend can use these details to pre-fill customer information in Stripe
      'billing_details': {
        'name': billingDetails.name,
        'email': billingDetails.email,
        'phone': billingDetails.phone,
        'address': {
          'line1': billingDetails.address?.line1 ?? '',
          'line2': billingDetails.address?.line2 ?? '',
          'city': billingDetails.address?.city ?? '',
          'state': billingDetails.address?.state ?? '',
          'postal_code': billingDetails.address?.postalCode ?? '',
          'country': billingDetails.address?.country ?? '',
        }
      }
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['error'] ?? 'Failed to create PaymentIntent.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}


//****************************************************************************
// New Screen for Stripe Payment Element
//****************************************************************************

class _StripePaymentScreen extends StatefulWidget {
  final String clientSecret;
  final double amount;

  const _StripePaymentScreen({
    required this.clientSecret,
    required this.amount,
  });

  @override
  State<_StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<_StripePaymentScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Donation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Donating: \$${widget.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Enter Payment Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // The PaymentElement is rendered here using the client secret.
              Container(
                height: 400,
                key: const ValueKey('stripe_payment_element'),
                child: PaymentElement(
                  clientSecret: widget.clientSecret,
                  onCardChanged: (_) {},
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmPayment,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Donation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For web, we use confirmPaymentElement
      await WebStripe.instance.confirmPaymentElement(
        const ConfirmPaymentElementOptions(
          confirmParams: ConfirmPaymentParams(
            return_url: 'https://beaforjp.com/#/donation-success',
          ),
        ),
      );

      if (!mounted) return;

      // Payment successful, show a success message and pop back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment Successful! Thank you for your donation.'),
          backgroundColor: Colors.green,
        ),
      );
      // Pop the payment screen and pass `true` to indicate success
      Navigator.of(context).pop(true);

    } on StripeException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.error.localizedMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e')),
        );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
