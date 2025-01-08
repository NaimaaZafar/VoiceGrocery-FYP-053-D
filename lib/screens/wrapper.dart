import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/screens/adminBhai.dart';
import 'package:fyp/screens/mainpage1.dart';
import 'login_or_reg.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle errors
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong. Please try again later.'),
            );
          }

          // User is logged in
          if (snapshot.hasData) {
            User? user = snapshot.data;

            // Fetch user role or additional data if needed
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasError) {
                  return Center(child: Text('Error loading user data.'));
                }
                if (userSnapshot.hasData) {
                  var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  if (userData['role'] == 'admin') {
                    return AdminPage();
                  } else {
                    return MainPage1();
                  }
                }
                return const LoginOrRegister();
              },
            );
          }

          // No user is logged in
          return const LoginOrRegister();
        },
      ),
    );
  }
}
