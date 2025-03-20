import 'package:flutter/material.dart';
import 'package:fyp/screens/add_new_card.dart';
import 'package:fyp/screens/delivery_options.dart';
import 'package:fyp/screens/success.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/widgets/button.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_dark, // Blue background
      appBar: AppBar(
        backgroundColor: bg_dark, // Consistent AppBar color
        title: const Text('Payment Details', style: TextStyle(color: Colors.white),),
        elevation: 0, // Flat AppBar
      ),
      body: Column(
        mainAxisAlignment:
        MainAxisAlignment.center, // Center content vertically
        children: [
          const Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text for contrast
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // Space between options
            children: [
              _buildPaymentOption(
                icon: Icons.money,
                label: 'Cash on Delivery',
                value: 'COD',
              ),
              _buildPaymentOption(
                icon: Icons.credit_card,
                label: 'Credit Card',
                value: 'Credit Card',
              ),
            ],
          ),
          const SizedBox(height: 40), // Space between options and button
      Button(
        onTap: () {
          if (_selectedPaymentMethod == 'Credit Card') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCardScreen(),
              ),
            );
          } else if (_selectedPaymentMethod == 'COD') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeliveryOptionScreen(paymentMethod: _selectedPaymentMethod!),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a payment method'),
              ),
            );
          }
        },
        text: "NEXT",
      ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 60, // Big icon size
            backgroundColor: _selectedPaymentMethod == value
                ? Colors.white
                : Colors.grey[300],
            child: Icon(
              icon,
              size: 50, // Larger icon size
              color:
              _selectedPaymentMethod == value ? Colors.blue : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: _selectedPaymentMethod == value
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: Colors.white, // White text
            ),
          ),
        ],
      ),
    );
  }
}