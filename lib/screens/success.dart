import 'package:flutter/material.dart';
import 'package:fyp/screens/category.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/widgets/button.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_dark, // Blue background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'asset/fullcart.json',
              height: 300, // Adjust height to fit the screen
              width: 300,  // Adjust width to fit the screen
              repeat: true, // Ensure the animation loops
            ),
            const SizedBox(height: 20),
            const Text(
              'Success',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for contrast
              ),
            ),
            const SizedBox(height: 20),
            Button(
              text: 'Continue Shopping',
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen(categoryName: 'FreshFruits')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
