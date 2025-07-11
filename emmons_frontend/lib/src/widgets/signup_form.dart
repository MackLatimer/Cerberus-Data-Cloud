import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode
import '../config.dart'; // Import the configuration file

class SignupFormWidget extends StatefulWidget {
  const SignupFormWidget({super.key});

  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();
}

import 'package:go_router/go_router.dart'; // Import for routing

class _SignupFormWidgetState extends State<SignupFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _endorseChecked = false;
  bool _getInvolvedChecked = false;
  bool _agreedToMessaging = false; // New state for messaging opt-in
  bool _agreedToEmails = false; // New state for email opt-in
  bool _isLoading = false; // To manage loading state

  // Controllers for text fields to easily access their values
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return; // Form is not valid
    }

    setState(() {
      _isLoading = true;
    });

    // Prepare data for submission
    // This structure should align with what your backend expects.
    // This is an example, assuming your backend /api/v1/signups or /api/v1/voters
    // can handle these fields.
    final signupData = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'email_address': _emailController.text,
      'phone_number': _phoneController.text.isNotEmpty ? _phoneController.text : null,
      'campaign_id': currentCampaignId, // From config.dart
      'interests': {
        'wants_to_endorse': _endorseChecked,
        'wants_to_get_involved': _getInvolvedChecked,
        'agreed_to_messaging': _agreedToMessaging, // Add new consent flag
        'agreed_to_emails': _agreedToEmails, // Add new consent flag
      },
      // You might also want to submit this as an interaction
      // or have the backend create an interaction record.
      // For example, an interaction of type 'Website Signup'.
      'interaction_type': 'Website Signup',
      'notes': 'Signed up via website form. Endorse: $_endorseChecked, Get Involved: $_getInvolvedChecked',
    };

    // Define the API endpoint.
    // This could be a generic 'signups' endpoint or directly creating a 'voter'
    // and logging an 'interaction'. For this example, let's assume a '/signups' endpoint.
    // Adjust if your backend uses a different structure (e.g. /voters and then /interactions)
    final url = Uri.parse('$apiBaseUrl/signups'); // Or perhaps '$apiBaseUrl/voters'

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(signupData),
      ).timeout(const Duration(seconds: defaultNetworkTimeoutSeconds));

      if (!mounted) return; // Check if the widget is still in the tree

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successfully submitted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you for signing up!'), backgroundColor: Colors.green),
        );
        _formKey.currentState?.reset();
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        setState(() {
          _endorseChecked = false;
          _getInvolvedChecked = false;
          _agreedToMessaging = false; // Reset new checkbox
          _agreedToEmails = false; // Reset new checkbox
        });
      } else {
        // Server returned an error
        // You might want to parse response.body if it contains error details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting form: ${response.statusCode}. Please try again.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // Network error or other exception
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e. Please check your connection and try again.'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Join the Movement!', style: textTheme.titleMedium),
            const SizedBox(height: 20),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'), // Removed "(Optional)"
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: Text('I endorse Curtis Emmons and allow him to publish my endorsement', style: textTheme.bodyMedium),
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
              title: Text('I want to get involved with the campaign!', style: textTheme.bodyMedium),
              value: _getInvolvedChecked,
              onChanged: (bool? value) {
                setState(() {
                  _getInvolvedChecked = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile( // New checkbox for automated messaging
              title: Text('I agree to receive automated messaging from Elect Emmons', style: textTheme.bodyMedium),
              value: _agreedToMessaging,
              onChanged: (bool? value) {
                setState(() {
                  _agreedToMessaging = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile( // New checkbox for emails
              title: Text('I agree to receive emails from Elect Emmons', style: textTheme.bodyMedium),
              value: _agreedToEmails,
              onChanged: (bool? value) {
                setState(() {
                  _agreedToEmails = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            Text( // Disclaimer text
              'Reply STOP to opt out, HELP for help. Msg & data rates may apply. Frequency may vary.',
              style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Sign Up'),
                    ),
            ),
            const SizedBox(height: 16), // Spacing before privacy policy link
            Center(
              child: TextButton(
                onPressed: () {
                  context.go('/privacy-policy'); // Navigate to Privacy Policy page
                },
                child: Text(
                  'Privacy Policy',
                  style: textTheme.bodyMedium?.copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
