import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/widgets/button.dart';

import '../widgets/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  Future forgetPass() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Password reset link sent!! \n Check your gmail",
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code.toString()}");
      ShowErrorMessage(e.message.toString() ?? "An error occurred");
    }
  }

  void ShowErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple,
          title: Center(
            child: Text(
              msg,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B57B2),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xFF3B57B2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Enter your Email and we will send you \n a link to reset the password",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 25),
          TextFieldInput(
            textEditingController: emailController,
            hintText: "Enter your email",
            obscureText: false,
            icon: Icons.email,
          ),
          const SizedBox(height: 25),
          Button(
            onTap: forgetPass,
            text: "SEND",
          ),
        ],
      ),
    );
  }

}
