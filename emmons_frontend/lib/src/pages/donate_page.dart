import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/dynamic_size_app_bar.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/donate_button.dart'; // Re-using for consistency
import 'package:candidate_website/src/network/stripe_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:candidate_website/src/widgets/footer.dart'; // Import the Footer widget

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  int? _selectedAmount;

  // Controllers for form fields
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

  // State variables for checkboxes
  bool _agreedToMessaging = false;
  bool _agreedToEmails = false;
  bool _coverTransactionFee = false;
  bool _showFullForm = false;

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
      extendBodyBehindAppBar: true,
      appBar: DynamicSizeAppBar(
        child: CommonAppBar(
          title: 'Donate to the Campaign',
          scrollController: _scrollController,
        ),
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
                        if (_currentStep == 0)
                          _buildDonationGrid(context)
                        else if (_currentStep == 1)
                          _buildDonorForm(context)
                        else
                          _buildPostDonationForm(context),
                        const SizedBox(height: 30),
                        if (_currentStep == 0)
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
            title: Text('I\'d like to help cover the transaction fees.', style: Theme.of(context).textTheme.bodyMedium),
            value: _coverTransactionFee,
            onChanged: (bool? value) {
              setState(() {
                _coverTransactionFee = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
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
            onPressed: _processDonation,
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
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? const Color(0xFF002663) : const Color(0xFFA01124),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text('\$$amount'),
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
          onChanged: (value) {
            setState(() {
              _selectedAmount = int.tryParse(value);
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStep = 1;
            });
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _processDonation() async {
    if (_formKey.currentState!.validate()) {
      final String? sessionId = await StripeService.createCheckoutSession(
        _selectedAmount.toString(),
        stripePublicKey,
      );

      if (sessionId != null) {
        final url = 'https://checkout.stripe.com/pay/$sessionId';
        if (await canLaunch(url)) {
          await launch(url);
          setState(() {
            _currentStep = 2;
          });
        } else {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Could not launch donation page'),
            ),
          );
        }
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Donation failed'),
          ),
        );
      }
    }
  }

  Widget _buildPostDonationForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Thank you for your donation!',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _buildTextFormField(label: 'Phone Number', controller: _phoneController, keyboardType: TextInputType.phone),
        _buildTextFormField(label: 'Email', controller: _emailController, isRequired: true, keyboardType: TextInputType.emailAddress),
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
          onPressed: () {
            // Handle submission of post-donation data
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18),
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _showDonationDataDialog() {
    // In a real app, you'd send this data to a server or payment processor
    final formData = {
      'First Name': _firstNameController.text,
      'Last Name': _lastNameController.text,
      'Address': _addressController.text,
      'Address Line 2': _addressLine2Controller.text,
      'City': _cityController.text,
      'State': _stateController.text,
      'ZIP': _zipController.text,
      'Email': _emailController.text,
      'Phone': _phoneController.text,
      'Employer': _employerController.text,
      'Occupation': _occupationController.text,
      'Agreed to Messaging': _agreedToMessaging.toString(),
      'Agreed to Emails': _agreedToEmails.toString(),
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Donation Information Received (Placeholder)'),
        content: SingleChildScrollView(
          child: ListBody(
            children: formData.entries
                .map((entry) => Text('${entry.key}: ${entry.value}'))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              // Optionally, clear form or navigate to a "thank you" or actual payment page
              // _formKey.currentState?.reset(); // Consider if this is desired UX
            },
          ),
        ],
      ),
    );
  }
}
