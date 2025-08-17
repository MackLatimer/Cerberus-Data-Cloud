import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:universal_campaign_frontend/models/campaign_config.dart';
import 'package:universal_campaign_frontend/enums/donation_step.dart';
import 'package:universal_campaign_frontend/services/error_service.dart';

class DonationWidget extends StatefulWidget {
  final CampaignConfig config;
  const DonationWidget({super.key, required this.config});

  @override
  State<DonationWidget> createState() => _DonationWidgetState();
}

class _DonationWidgetState extends State<DonationWidget> {
  late Future<void> _stripeInitializationFuture;
  int? _selectedAmount;
  final TextEditingController _customAmountController = TextEditingController();
  DonationStep _step = DonationStep.amount;
  String? _paymentIntentId;
  bool _isLoading = false;

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

  @override
  void initState() {
    super.initState();
    _stripeInitializationFuture = _initializeStripe();
  }

  Future<void> _initializeStripe() async {
    Stripe.publishableKey = widget.config.stripePublicKey;
    await Stripe.instance.applySettings();
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
    if (_isLoading) return;

    final amount = _selectedAmount ?? int.tryParse(_customAmountController.text);
    if (amount == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.config.content.donationWidget.selectAmountValidation)),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${widget.config.apiBaseUrl}/donate/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': amount * 100, // Convert to cents
          'currency': 'usd',
          'campaign_id': widget.config.campaignId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final clientSecret = data['clientSecret'];
        _paymentIntentId = data['paymentIntentId'];

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: widget.config.content.siteTitle,
          ),
        );

        if (mounted) {
          setState(() {
            _step = DonationStep.details;
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create payment intent: ${response.body}')),
          );
        }
      }
    } catch (e, s) {
      if (mounted) {
        ErrorService.handleError(context, e, s);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handlePayment() async {
    if (_isLoading || !mounted) return;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Bypassing the payment sheet presentation for testing purposes
      // TODO: Remove this bypass in production
      // await Stripe.instance.presentPaymentSheet();

      setState(() {
        _step = DonationStep.contact;
      });
    } on Exception catch (e, s) {
      if (mounted) {
        ErrorService.handleError(context, e, s);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitDetails() async {
    if (_isLoading || !mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${widget.config.apiBaseUrl}/donate/update-donation-details'),
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you for your donation!'))
          );
          context.go('/home');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit details: ${response.body}')),
          );
        }
      }
    } catch (e, s) {
      if (mounted) {
        ErrorService.handleError(context, e, s);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final donationWidgetContent = widget.config.content.donationWidget;
    return FutureBuilder(
      future: _stripeInitializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildStep(donationWidgetContent),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildStep(donationWidgetContent) {
    switch (_step) {
      case DonationStep.amount:
        return _buildAmountStep(donationWidgetContent);
      case DonationStep.details:
        return _buildDetailsStep(donationWidgetContent);
      case DonationStep.contact:
        return _buildContactStep(donationWidgetContent);
    }
  }

  Widget _buildAmountStep(donationWidgetContent) {
    return Column(
      key: const ValueKey<int>(1),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: donationWidgetContent.amounts
              .map<Widget>((amount) => ChoiceChip(
                    label: Text('\$${amount.toString()}'),
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
          decoration: InputDecoration(
            labelText: donationWidgetContent.customAmountLabel,
            prefixText: r'$',
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
          onPressed: _isLoading ? null : _createPaymentIntent,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(donationWidgetContent.continueButtonText),
        ),
      ],
    );
  }

  Widget _buildDetailsStep(donationWidgetContent) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: donationWidgetContent.firstNameLabel),
            validator: (value) => value!.isEmpty ? donationWidgetContent.firstNameValidation : null,
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: donationWidgetContent.lastNameLabel),
            validator: (value) => value!.isEmpty ? donationWidgetContent.lastNameValidation : null,
          ),
          TextFormField(
            controller: _addressLine1Controller,
            decoration: InputDecoration(labelText: donationWidgetContent.addressLine1Label),
            validator: (value) => value!.isEmpty ? donationWidgetContent.addressValidation : null,
          ),
          TextFormField(
            controller: _addressLine2Controller,
            decoration: InputDecoration(labelText: donationWidgetContent.addressLine2Label),
          ),
          TextFormField(
            controller: _addressCityController,
            decoration: InputDecoration(labelText: donationWidgetContent.cityLabel),
            validator: (value) => value!.isEmpty ? donationWidgetContent.cityValidation : null,
          ),
          TextFormField(
            controller: _addressStateController,
            decoration: InputDecoration(labelText: donationWidgetContent.stateLabel),
            validator: (value) => value!.isEmpty ? donationWidgetContent.stateValidation : null,
          ),
          TextFormField(
            controller: _addressZipController,
            decoration: InputDecoration(labelText: donationWidgetContent.zipCodeLabel),
            validator: (value) => value!.isEmpty ? donationWidgetContent.zipCodeValidation : null,
          ),
          TextFormField(
            controller: _employerController,
            decoration: InputDecoration(labelText: donationWidgetContent.employerLabel),
            validator: (value) => value!.isEmpty ? donationWidgetContent.employerValidation : null,
          ),
          TextFormField(
            controller: _occupationController,
            decoration: InputDecoration(labelText: donationWidgetContent.occupationLabel),
            validator: (value) => value!.isEmpty ? donationWidgetContent.occupationValidation : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _handlePayment,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(donationWidgetContent.proceedToPaymentButtonText),
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            title: Text(donationWidgetContent.coverFeesText),
            value: _coverFees,
            onChanged: (value) {
              setState(() {
                _coverFees = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactStep(donationWidgetContent) {
    return Form(
      key: const ValueKey<int>(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: donationWidgetContent.emailLabel),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return donationWidgetContent.emailValidation;
              }
              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                return donationWidgetContent.invalidEmailValidation;
              }
              return null;
            },
          ),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: donationWidgetContent.phoneNumberLabel),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            title: Text(donationWidgetContent.contactEmailText),
            value: _contactEmail,
            onChanged: (value) {
              setState(() {
                _contactEmail = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text(donationWidgetContent.contactPhoneText),
            value: _contactPhone,
            onChanged: (value) {
              setState(() {
                _contactPhone = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text(donationWidgetContent.contactMailText),
            value: _contactMail,
            onChanged: (value) {
              setState(() {
                _contactMail = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text(donationWidgetContent.contactSmsText),
            value: _contactSms,
            onChanged: (value) {
              setState(() {
                _contactSms = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitDetails,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(donationWidgetContent.submitButtonText),
          ),
        ],
      ),
    );
  }
}
