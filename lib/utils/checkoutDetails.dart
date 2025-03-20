import 'package:flutter/material.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/utils/payment_details.dart';
import 'package:fyp/widgets/button.dart';
import 'package:fyp/widgets/text_field.dart';
import 'package:fyp/widgets/dropdown_input.dart';

class CheckoutDetails extends StatefulWidget {
  const CheckoutDetails({super.key});

  @override
  _CheckoutDetailsState createState() => _CheckoutDetailsState();
}

class _CheckoutDetailsState extends State<CheckoutDetails> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  final List<String> _provinces = ['Punjab', 'Sindh', 'KPK'];
  String? _selectedProvince = 'Punjab'; // Default value

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    } else if (!RegExp(r'^\d{5}$').hasMatch(value)) {
      return 'Enter a valid 5-digit postal code';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Details', style: TextStyle(color: Colors.white)),
        backgroundColor: bg_dark,
      ),
      body: Container(
        color: bg_dark,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFieldInput(
                textEditingController: _fullNameController,
                hintText: 'Enter your full name',
                icon: Icons.person,
                obscureText: false,
                validator: (value) => _validateField(value, 'Full Name'),
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                textEditingController: _phoneNumberController,
                hintText: 'Enter your phone number',
                icon: Icons.phone,
                obscureText: false,
                validator: _validatePhoneNumber,
              ),
              const SizedBox(height: 10),
              DropdownInput(
                hintText: 'Select Province',
                items: _provinces,
                selectedItem: _selectedProvince,
                onChanged: (value) {
                  setState(() {
                    _selectedProvince = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                textEditingController: _cityController,
                hintText: 'Enter your city',
                icon: Icons.location_city,
                obscureText: false,
                validator: (value) => _validateField(value, 'City'),
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                textEditingController: _addressController,
                hintText: 'Enter your address',
                icon: Icons.home,
                obscureText: false,
                validator: (value) => _validateField(value, 'Address'),
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                textEditingController: _postalCodeController,
                hintText: 'Enter your postal code',
                icon: Icons.local_post_office,
                obscureText: false,
                validator: _validatePostalCode,
              ),
              const SizedBox(height: 20),
              Button(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentDetailsScreen()),
                    );
                  }
                },
                text: 'Proceed to Payment',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
