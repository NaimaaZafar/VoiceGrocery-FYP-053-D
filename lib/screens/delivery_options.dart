import 'package:flutter/material.dart';
import 'package:fyp/screens/success.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/utils/email_service.dart'; // Create this for sending emails
import 'package:fyp/widgets/button.dart';

class DeliveryOptionScreen extends StatefulWidget {
  final String paymentMethod;

  const DeliveryOptionScreen({super.key, required this.paymentMethod});

  @override
  State<DeliveryOptionScreen> createState() => _DeliveryOptionScreenState();
}

class _DeliveryOptionScreenState extends State<DeliveryOptionScreen> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_dark,
      appBar: AppBar(title: const Text("Delivery Option")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Would you like delivery?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOption("Yes", "YES"),
              _buildOption("No", "NO"),
            ],
          ),
          const SizedBox(height: 40),
          Button(
            onTap: () async {
              if (_selectedOption == "YES") {
                await sendOrderConfirmationEmail(); // Send email
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SuccessScreen()),
              );
            },
            text: "CONFIRM",
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedOption == value ? Colors.white : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
