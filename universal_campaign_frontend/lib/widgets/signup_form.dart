import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:universal_campaign_frontend/models/campaign_config.dart';

const int defaultNetworkTimeoutSeconds = 10;

class SignupFormWidget extends StatefulWidget {
  final CampaignConfig config;
  const SignupFormWidget({super.key, required this.config});

  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _endorseChecked = false;
  bool _getInvolvedChecked = false;
  bool _agreedToMessaging = false;
  bool _agreedToEmails = false;
  bool _isLoading = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final signupData = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'email_address': _emailController.text,
      'phone_number': _phoneController.text.isNotEmpty ? _phoneController.text : null,
      'campaign_id': widget.config.campaignId,
      'interests': {
        'wants_to_endorse': _endorseChecked,
        'wants_to_get_involved': _getInvolvedChecked,
        'agreed_to_messaging': _agreedToMessaging,
        'agreed_to_emails': _agreedToEmails,
      },
      'interaction_type': 'Website Signup',
      'notes': 'Signed up via website form. Endorse: $_endorseChecked, Get Involved: $_getInvolvedChecked',
    };

    final url = Uri.parse('${widget.config.apiBaseUrl}/signups');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(signupData),
      ).timeout(const Duration(seconds: defaultNetworkTimeoutSeconds));

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
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
          _agreedToMessaging = false;
          _agreedToEmails = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting form: ${response.statusCode}. Please try again.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.config.content.signupForm.title, style: textTheme.titleMedium),
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
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: Text(widget.config.content.widgets.signupForm.endorseText, style: textTheme.bodyMedium),
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
                  title: Text(widget.config.content.widgets.signupForm.getInvolvedText, style: textTheme.bodyMedium),
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
                  title: Text(widget.config.content.widgets.signupForm.automatedMessagingText, style: textTheme.bodyMedium),
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
                  title: Text(widget.config.content.widgets.signupForm.emailOptInText, style: textTheme.bodyMedium),
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
                Text(
                  widget.config.content.signupForm.legalText,
                  style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 24),
                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(widget.config.content.widgets.signupForm.buttonText),
                        ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.go('/privacy-policy');
                    },
                    child: Text(
                      widget.config.content.signupForm.privacyPolicyText,
                      style: textTheme.bodyMedium?.copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}