import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
// Re-using for consistency
// import 'package:url_launcher/url_launcher.dart'; // For actual donation link later
import 'package:candidate_website/src/widgets/footer.dart'; // Import the Footer widget
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class DonatePage extends StatefulWidget {
  final http.Client? httpClient;

  const DonatePage({super.key, this.httpClient});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  late http.Client _httpClient;
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool _showFullForm = false;
  int? _selectedAmount;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _employerController = TextEditingController();
  final _occupationController = TextEditingController();

  bool _agreedToMessaging = false;
  bool _agreedToEmails = false;
  bool _endorseChecked = false;
  bool _getInvolvedChecked = false;

  @override
  void initState() {
    super.initState();
    _httpClient = widget.httpClient ?? http.Client();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _employerController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: 'Support the Campaign',
        scrollController: _scrollController,
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height, // Height of the hero image
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Hero_Picture_Donate.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600), // Slightly narrower for focus
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 40),
                        Text(
                          'Support our Mission!',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        _buildDonationGrid(context),
                        const SizedBox(height: 30),
                        if (_showFullForm)
                          _buildDonorForm(context)
                        else
                          Container(),
                        if (!_showFullForm)
                          Text(
                            'Contributions to the Curtis Emmons for County Commissioner campaign help us reach voters, share our message, and work towards a better future for Bell County Precinct 4. Every donation, no matter the size, is deeply appreciated and crucial to our success.',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 40),
                        if (!_showFullForm)
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
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonorForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Donor Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildTextFormField(label: 'First Name', controller: _firstNameController, isRequired: true),
          _buildTextFormField(label: 'Last Name', controller: _lastNameController, isRequired: true),
          _buildTextFormField(label: 'Street Address', controller: _addressController, isRequired: true),
          _buildTextFormField(label: 'Address Line 2', controller: _addressLine2Controller), // Added Address Line 2
          _buildTextFormField(label: 'City', controller: _cityController, isRequired: true),
          _buildTextFormField(label: 'State', controller: _stateController, isRequired: true),
          _buildTextFormField(label: 'ZIP Code', controller: _zipController, isRequired: true, keyboardType: TextInputType.number),
          _buildTextFormField(label: 'Email', controller: _emailController, isRequired: true, keyboardType: TextInputType.emailAddress),
          _buildTextFormField(label: 'Phone Number', controller: _phoneController, keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          // Removed 'For campaign finance reporting purposes...' text
          _buildTextFormField(label: 'Employer', controller: _employerController),
          _buildTextFormField(label: 'Occupation', controller: _occupationController),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: Text('I agree to receive automated messaging from Elect Emmons', style: Theme.of(context).textTheme.bodyMedium),
            value: _agreedToMessaging,
            onChanged: (bool? value) {
              setState(() {
                _agreedToMessaging = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            title: Text('I agree to receive emails from Elect Emmons', style: Theme.of(context).textTheme.bodyMedium),
            value: _agreedToEmails,
            onChanged: (bool? value) {
              setState(() {
                _agreedToEmails = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handlePayPress,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18),
            ),
            child: const Text('Proceed to Donation'),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePayPress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // 1. Create a payment intent on the server
    final paymentIntent = await _createPaymentIntent(_selectedAmount ?? 0, 'usd');

    if (paymentIntent == null) {
      // Handle error
      return;
    }

    // 2. Initialize the payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent['client_secret'],
        merchantDisplayName: 'Emmons for Commissioner',
      ),
    );

    // 3. Present the payment sheet
    await _displayPaymentSheet();
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(int amount, String currency) async {
    try {
      //TODO: Move this to a secure backend
      final response = await _httpClient!.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: {
          'amount': (amount * 100).toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
        headers: {
          'Authorization': 'Bearer YOUR_STRIPE_SECRET_KEY', // Replace with your actual key
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating payment intent: $e')),
      );
      return null;
    }
  }

  Future<void> _displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      _showPostDonationDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error displaying payment sheet: $e')),
      );
    }
  }

  void _showPostDonationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thank You For Your Donation!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Please provide some additional information:'),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              CheckboxListTile(
                title: const Text('I endorse Curtis Emmons and allow him to publish my endorsement'),
                value: _endorseChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _endorseChecked = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('I want to get involved with the campaign!'),
                value: _getInvolvedChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _getInvolvedChecked = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('I agree to receive automated messaging from Elect Emmons'),
                value: _agreedToMessaging,
                onChanged: (bool? value) {
                  setState(() {
                    _agreedToMessaging = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('I agree to receive emails from Elect Emmons'),
                value: _agreedToEmails,
                onChanged: (bool? value) {
                  setState(() {
                    _agreedToEmails = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Submit'),
            onPressed: () {
              // In a real app, you would send this additional information
              // to your backend for storage and processing.
              // For example:
              //
              // final success = await ApiService.submitAdditionalInfo(
              //   phone: _phoneController.text,
              //   email: _emailController.text,
              //   endorse: _endorseChecked,
              //   getInvolved: _getInvolvedChecked,
              //   agreedToMessaging: _agreedToMessaging,
              //   agreedToEmails: _agreedToEmails,
              // );
              //
              // if (success) {
              //   Navigator.of(context).pop();
              // } else {
              //   // Handle submission error
              // }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface.withAlpha(50),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return '$label is required';
                }
                if (label == 'Email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                // Basic ZIP code validation (US)
                if (label == 'ZIP Code' && !RegExp(r'^\d{5}(-\d{4})?$').hasMatch(value)) {
                    return 'Please enter a valid ZIP code';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildDonationGrid(BuildContext context) {
    final amounts = [10, 25, 50, 100, 250, 500, 1000, 2500, 5000];
    final customAmountController = TextEditingController();
    return Column(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5,
          ),
          itemCount: amounts.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final amount = amounts[index];
            final isSelected = _selectedAmount == amount;
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedAmount = amount;
                  _showFullForm = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? const Color(0xFF002663) : const Color(0xFFA01124),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text('\$${amounts[index]}'),
            );
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: customAmountController,
          decoration: InputDecoration(
            labelText: 'Custom Amount',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Color(0xffa01124),
                width: 3.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Color(0xffa01124),
                width: 3.0,
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          onTap: () {
            setState(() {
              _selectedAmount = null;
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showFullForm = true;
            });
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
