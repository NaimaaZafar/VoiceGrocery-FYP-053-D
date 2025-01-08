import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image symbol for logout
            Image.asset(
              'assets/logout_icon.png', // Replace with your image path
              height: 100, // Adjust the size as needed
              width: 100, // Adjust the size as needed
            ),
            const SizedBox(height: 20),

            // Paragraph explaining the logout process
            const Text(
              'Are you sure you want to log out? Logging out will end your current session, and you will need to sign in again to access your account.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Logout button
            ElevatedButton(
              onPressed: () {
                // Handle Logout action (e.g., navigate to login page)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You have been logged out.')),
                );
                // Example: Navigate to login page
                // Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Dark blue background
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                    fontSize: 18, color: Colors.red), // Red text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
