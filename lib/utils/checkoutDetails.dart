import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/utils/payment_details.dart';
import 'package:fyp/widgets/button.dart';
import 'package:fyp/widgets/text_field.dart';

class CheckoutDetails extends StatefulWidget {
  const CheckoutDetails({super.key});

  @override
  _CheckoutDetailsState createState() => _CheckoutDetailsState();
}

class _CheckoutDetailsState extends State<CheckoutDetails> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _fullNameController.text = data['fullName'] ?? '';
          _phoneNumberController.text = data['phoneNumber'] ?? '';
          _cityController.text = data['city'] ?? '';
          _addressController.text = data['address'] ?? '';
        });
      }
    }
  }

  Future<void> _saveUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'fullName': _fullNameController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'city': _cityController.text.trim(),
        'address': _addressController.text.trim(),
      }, SetOptions(merge: true));
    }
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
              const SizedBox(height: 20),
              Button(
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await _saveUserData(); // Save data to Firebase
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
