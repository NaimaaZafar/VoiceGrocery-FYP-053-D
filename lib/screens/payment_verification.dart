import 'package:flutter/material.dart';
import 'package:fyp/screens/success.dart';
import 'package:fyp/utils/colors.dart';

class PaymentVerificationScreen extends StatefulWidget {
  const PaymentVerificationScreen({super.key});

  @override
  _PaymentVerificationScreenState createState() =>
      _PaymentVerificationScreenState();
}

class _PaymentVerificationScreenState extends State<PaymentVerificationScreen> {
  bool _isVerifying = true;

  @override
  void initState() {
    super.initState();
    _simulatePaymentVerification();
  }

  void _simulatePaymentVerification() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isVerifying = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_dark,
      body: Center(
        child: _isVerifying
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Verifying Payment...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        )
            : const Text(
          'Payment has been deducted',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}