import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/mainpage1.dart';
import 'package:fyp/widgets/button.dart';
import 'package:fyp/widgets/square_tile.dart';
import 'package:fyp/widgets/text_field.dart';
import 'package:fyp/screens/login.dart';

class SignupScreen extends StatefulWidget {
  final Function()? onTap;
  const SignupScreen({super.key, required this.onTap});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();
  final TextEditingController phonenumControllter = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    phonenumControllter.dispose();
    super.dispose();
  }

  void singuserup() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //authenticating the user
    try {
      if (passwordController.text == confirmpasswordController.text){
        //create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        
        addUserDetails(
            firstnameController.text.trim(),
            lastnameController.text.trim(),
            phonenumControllter.text.trim(),
            emailController.text.trim()
        );

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage1()),
        );
      }
      else{
        ShowErrorMessage("Passwords do not match");
      }
    } on FirebaseAuthException catch (e) {
      ShowErrorMessage(e.code);
    }
  }

  Future addUserDetails(String firstName, String lastName, String phoneNumber, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'phone number': phoneNumber,
      'email':email,
    });
  }

  void ShowErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple[200],
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
    final isKeyboard = MediaQuery
        .of(context)
        .viewInsets
        .bottom != 0;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: const Color(0xFF3B57B2),
      body: SafeArea(
        child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // const Icon(
                  //   Icons.arrow_back_ios,
                  //   size: 20,
                  //   color: Colors.white,
                  // ),
                  const Text(
                    "SignUp",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFieldInput(
                    textEditingController: emailController,
                    hintText: "Enter your email",
                    obscureText: false,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    textEditingController: firstnameController,
                    hintText: "First Name",
                    obscureText: false,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    textEditingController: lastnameController,
                    hintText: "Last Name",
                    obscureText: false,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    textEditingController: passwordController,
                    hintText: "Enter your password",
                    obscureText: true,
                    icon: Icons.password,
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    textEditingController: confirmpasswordController,
                    hintText: "Confirm your password",
                    obscureText: true,
                    icon: Icons.password,
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    textEditingController: phonenumControllter,
                    hintText: "Enter your phone number",
                    obscureText: false,
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 25),
                  Button(
                    text: "SIGNUP",
                    onTap: singuserup,
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "or continue with",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(imagePath: 'asset/google.png'),
                      SizedBox(width: 20),
                      SquareTile(imagePath: 'asset/meta.png')
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen(onTap: widget.onTap)),
                          );
                        },  // Calls togglePages() from LoginOrRegister
                        child: const Text(
                          'Login Now',
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}