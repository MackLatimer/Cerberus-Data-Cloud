import 'package:flutter/material.dart';
import 'package:candidate_website/src/network/stripe_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:candidate_website/src/config.dart';

class DonationWidget extends StatefulWidget {
  const DonationWidget({super.key});

  @override
  State<DonationWidget> createState() => _DonationWidgetState();
}

class _DonationWidgetState extends State<DonationWidget> {
  int? _selectedAmount;
  final TextEditingController _customAmountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _agreedToMessaging = false;
  bool _agreedToEmails = false;
  bool _showPostDonationForm = false;

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    if (uri.queryParameters['success'] == 'true') {
      _showPostDonationForm = true;
    }
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _processDonation() async {
    if (_selectedAmount == null || _selectedAmount! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid donation amount.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String? sessionId = await StripeService.createCheckoutSession(
      _selectedAmount.toString(),
      stripePublicKey,
    );

    if (sessionId != null) {
      final url = Uri.parse('https://checkout.stripe.com/pay/$sessionId');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Could not launch donation page'),
          ),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Donation failed'),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    if (_showPostDonationForm) {
      return _buildPostDonationForm(context);
    }

    final amounts = [10, 25, 50, 100, 250, 500, 1000, 2500, 5000];
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
                  _customAmountController.clear();
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
          controller: _customAmountController,
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
          onPressed: _processDonation,
          child: const Text('Donate'),
        ),
      ],
    );
  }
}
