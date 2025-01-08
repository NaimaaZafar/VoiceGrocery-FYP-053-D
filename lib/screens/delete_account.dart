import 'package:flutter/material.dart';
import 'package:fyp/screens/splashscreen.dart';
import 'package:fyp/widgets/button.dart';
import 'package:lottie/lottie.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image symbol for account deletion (use a different image for delete account)
            LottieBuilder.asset(
              'asset/girlwithcart.json',
              height: 300, // Adjust height to fit the screen
              width: 300,  // Adjust width to fit the screen
              repeat: true, // Ensure the animation loops
            ),
            const SizedBox(height: 20),

            // Text explaining the account deletion process
            const Text(
              'Are you sure you want to delete your account? This action is irreversible and will permanently remove all your data.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Delete Account button
            Button(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Splashscreen()));
            }, text: "DELETE"
            )
          ],
        ),
      ),
    );
  }
}
