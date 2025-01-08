import 'package:flutter/material.dart';
import 'package:fyp/screens/login.dart';
import 'package:fyp/screens/signup.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegState();
}

class _LoginOrRegState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;  // This toggles the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoginPage
          ? LoginScreen(onTap: togglePages)  // If true, show LoginScreen
          : SignupScreen(onTap: togglePages),  // If false, show SignupScreen
    );
  }
}