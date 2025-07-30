import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostDonationDetailsPage extends StatefulWidget {
  final String? sessionId;

  const PostDonationDetailsPage({super.key, required this.sessionId});

  @override
  State<PostDonationDetailsPage> createState() => _PostDonationDetailsPageState();
}

class _PostDonationDetailsPageState extends State<PostDonationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _addressCityController = TextEditingController();
  final TextEditingController _addressStateController = TextEditingController();
  final TextEditingController _addressZipController = TextEditingController();
  final TextEditingController _employerController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _contactEmail = false;
  bool _contactPhone = false;
  bool _contactMail = false;
  bool _contactSms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _addressCityController.dispose();
    _addressStateController.dispose();
    _addressZipController.dispose();
    _employerController.dispose();
    _occupationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitDetails() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        'session_id': widget.sessionId,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'address_line1': _addressLine1Controller.text,
        'address_line2': _addressLine2Controller.text,
        'address_city': _addressCityController.text,
        'address_state': _addressStateController.text,
        'address_zip': _addressZipController.text,
        'employer': _employerController.text,
        'occupation': _occupationController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'contact_email': _contactEmail,
        'contact_phone': _contactPhone,
        'contact_mail': _contactMail,
        'contact_sms': _contactSms,
      };

      try {
        final response = await http.post(
          Uri.parse('https://campaigns-api-885603051818.us-south1.run.app/api/v1/update-donation-details'), // Use your backend URL
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Details submitted successfully!')),
            );
            context.go('/'); // Navigate back to home or a thank you page
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to submit details: ${response.body}')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting details: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sessionId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Session ID not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Provide Additional Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              TextFormField(
                controller: _addressLine1Controller,
                decoration: const InputDecoration(labelText: 'Address Line 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressLine2Controller,
                decoration: const InputDecoration(labelText: 'Address Line 2 (Optional)'),
              ),
              TextFormField(
                controller: _addressCityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressStateController,
                decoration: const InputDecoration(labelText: 'State'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your state';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressZipController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your zip code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _employerController,
                decoration: const InputDecoration(labelText: 'Employer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your employer';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _occupationController,
                decoration: const InputDecoration(labelText: 'Occupation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your occupation';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Contact Preferences:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('Contact me via Email'),
                value: _contactEmail,
                onChanged: (bool? value) {
                  setState(() {
                    _contactEmail = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Contact me via Phone Call'),
                value: _contactPhone,
                onChanged: (bool? value) {
                  setState(() {
                    _contactPhone = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Contact me via Mail'),
                value: _contactMail,
                onChanged: (bool? value) {
                  setState(() {
                    _contactMail = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Contact me via SMS'),
                value: _contactSms,
                onChanged: (bool? value) {
                  setState(() {
                    _contactSms = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitDetails,
                child: const Text('Submit Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
