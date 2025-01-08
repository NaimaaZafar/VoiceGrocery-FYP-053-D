import 'package:flutter/material.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/utils/payment_details.dart';
import 'package:fyp/widgets/button.dart';
import 'package:fyp/widgets/text_field.dart';
import 'package:fyp/widgets/dropdown_input.dart';

// Checkout Details Screen
class CheckoutDetails extends StatefulWidget {
  const CheckoutDetails({super.key});

  @override
  _CheckoutDetailsState createState() => _CheckoutDetailsState();
}

class _CheckoutDetailsState extends State<CheckoutDetails> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  // Province options
  final List<String> _provinces = ['Punjab', 'Sindh', 'KPK'];
  String? _selectedProvince;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Details', style: TextStyle(color: Colors.white),),
        backgroundColor: bg_dark,
      ),
      body: Container(
        color: bg_dark, // Dark Blue background
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
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                textEditingController: _phoneNumberController,
                hintText: 'Enter your phone number',
                icon: Icons.phone,
                obscureText: false,
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
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                textEditingController: _addressController,
                hintText: 'Enter your address',
                icon: Icons.home,
                obscureText: false,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                textEditingController: _postalCodeController,
                hintText: 'Enter your postal code',
                icon: Icons.local_post_office,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              Button(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Navigate to PaymentDetails screen after submitting order
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentDetailsScreen()),
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
