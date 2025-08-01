
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:candidate_website/src/config.dart';
import 'package:candidate_website/src/services/stripe_service.dart';
import 'package:candidate_website/src/widgets/stripe_element.dart';
import 'dart:js' as js;

class DonationWidget extends StatefulWidget {
  const DonationWidget({super.key});

  @override
  State<DonationWidget> createState() => _DonationWidgetState();
}

class _DonationWidgetState extends State<DonationWidget> {
  int? _selectedAmount;
  final TextEditingController _customAmountController = TextEditingController();
  int _step = 1;
  String? _paymentIntentId;
  String? _clientSecret;

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

  bool _coverFees = false;
  bool _isRecurring = false;
  bool _contactEmail = false;
  bool _contactPhone = false;
  bool _contactMail = false;
  bool _contactSms = false;

  late final StripeService _stripeService;
  StripeElement? _cardElement;
  bool _stripeInitialized = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _stripeService = StripeService(stripePublicKey);
        _stripeService.init().then((_) {
          if (mounted) {
            setState(() {
              _stripeInitialized = true;
            });
          }
        }).catchError((e) {
          print("Error initializing Stripe: $e");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error loading payment provider. Please refresh the page.')),
            );
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _customAmountController.dispose();
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

  Future<void> _createPaymentIntent() async {
    final amount = _selectedAmount ?? int.tryParse(_customAmountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter an amount')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://campaigns-api-885603051818.us-south1.run.app/api/v1/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': amount.toString(),
          'currency': 'usd',
          'is_recurring': _isRecurring,
          'covers_fees': _coverFees,
          'email': _emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _clientSecret = data['clientSecret'];
          _paymentIntentId = data['paymentIntentId'];
          _step = 2;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create payment intent: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating payment intent: $e')),
      );
    }
  }

  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_clientSecret == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment intent not created')),
      );
      return;
    }

    try {
      final billingDetails = {
        'name': '${_firstNameController.text} ${_lastNameController.text}',
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': {
          'line1': _addressLine1Controller.text,
          'line2': _addressLine2Controller.text,
          'city': _addressCityController.text,
          'state': _addressStateController.text,
          'postal_code': _addressZipController.text,
          'country': 'US',
        },
      };

      final result = await _stripeService.confirmPayment(
        _clientSecret!,
        _cardElement!.element,
        billingDetails,
      );

      if (result.hasProperty('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${result['error']['message']}')),
        );
      } else {
        setState(() {
          _step = 3;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment: $e')),
      );
    }
  }

  Future<void> _submitDetails() async {
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
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you for your donation!')),
        );
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit details: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_stripeInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _buildCurrentStep(),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 1:
        return _buildAmountStep();
      case 2:
        return _buildDetailsStep();
      case 3:
        return _buildContactStep();
      default:
        return Container();
    }
  }

  Widget _buildAmountStep() {
    return Column(
      key: const ValueKey<int>(1),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [25, 50, 100, 250, 500, 1000]
              .map((amount) => ChoiceChip(
                    label: Text('\$$amount'),
                    selected: _selectedAmount == amount,
                    onSelected: (selected) {
                      setState(() {
                        _selectedAmount = selected ? amount : null;
                        if (selected) {
                          _customAmountController.clear();
                        }
                      });
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _customAmountController,
          decoration: const InputDecoration(
            labelText: 'Custom Amount',
            prefixText: '\$',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _selectedAmount = null;
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _createPaymentIntent,
          child: const Text('Continue'),
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    if (_cardElement == null && _stripeService.elements != null) {
      _cardElement = StripeElement(_stripeService.elements!.callMethod('create', ['card']));
      Future.delayed(const Duration(milliseconds: 100), () {
        _cardElement?.mount('#card-element');
      });
    }
    return Form(
      key: const ValueKey<int>(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
            validator: (value) => value!.isEmpty ? 'Please enter your first name' : null,
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
            validator: (value) => value!.isEmpty ? 'Please enter your last name' : null,
          ),
          TextFormField(
            controller: _addressLine1Controller,
            decoration: const InputDecoration(labelText: 'Address Line 1'),
            validator: (value) => value!.isEmpty ? 'Please enter your address' : null,
          ),
          TextFormField(
            controller: _addressLine2Controller,
            decoration: const InputDecoration(labelText: 'Address Line 2 (Optional)'),
          ),
          TextFormField(
            controller: _addressCityController,
            decoration: const InputDecoration(labelText: 'City'),
            validator: (value) => value!.isEmpty ? 'Please enter your city' : null,
          ),
          TextFormField(
            controller: _addressStateController,
            decoration: const InputDecoration(labelText: 'State'),
            validator: (value) => value!.isEmpty ? 'Please enter your state' : null,
          ),
          TextFormField(
            controller: _addressZipController,
            decoration: const InputDecoration(labelText: 'Zip Code'),
            validator: (value) => value!.isEmpty ? 'Please enter your zip code' : null,
          ),
          TextFormField(
            controller: _employerController,
            decoration: const InputDecoration(labelText: 'Employer'),
            validator: (value) => value!.isEmpty ? 'Please enter your employer' : null,
          ),
          TextFormField(
            controller: _occupationController,
            decoration: const InputDecoration(labelText: 'Occupation'),
            validator: (value) => value!.isEmpty ? 'Please enter your occupation' : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: HtmlElementView(viewType: 'card-element'),
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            title: const Text('Cover transaction fees'),
            value: _coverFees,
            onChanged: (value) {
              setState(() {
                _coverFees = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Make this a recurring monthly donation'),
            value: _isRecurring,
            onChanged: (value) {
              setState(() {
                _isRecurring = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handlePayment,
            child: const Text('Submit Payment'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactStep() {
    return Form(
      key: const ValueKey<int>(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
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
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            title: const Text('Contact me via Email'),
            value: _contactEmail,
            onChanged: (value) {
              setState(() {
                _contactEmail = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Contact me via Phone Call'),
            value: _contactPhone,
            onChanged: (value) {
              setState(() {
                _contactPhone = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Contact me via Mail'),
            value: _contactMail,
            onChanged: (value) {
              setState(() {
                _contactMail = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Contact me via SMS'),
            value: _contactSms,
            onChanged: (value) {
              setState(() {
                _contactSms = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitDetails,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
