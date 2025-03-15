import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/screens/category.dart';
import 'package:fyp/screens/fav.dart';
import 'package:fyp/screens/settings.dart';
import 'package:fyp/screens/voice_recognition.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/widgets/button.dart';
import 'package:fyp/widgets/navbar.dart';
import 'package:fyp/widgets/text_field.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _nameController.text = userDoc['name'] ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = userDoc['phone'] ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          if (_emailController.text != user.email) {
            await user.updateEmail(_emailController.text);
          }

          if (_newPasswordController.text.isNotEmpty) {
            await user.updatePassword(_newPasswordController.text);
          }

          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'name': _nameController.text,
            'phone': _phoneController.text,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile Updated Successfully')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  int _selectedIndex = 2;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const CategoryScreen(categoryName: '')));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const FavScreen()));
    } else if (index == 2) {
      // We're already on the Profile screen
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
    } else if (index == 4) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const VoiceRecognitionScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg_dark,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('My Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CategoryScreen(categoryName: 'MeatsFishes')),
            );
          },
        ),
      ),
      backgroundColor: bg_dark,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                    'https://example.com/user_image.jpg'),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFieldInput(
                    textEditingController: _nameController,
                    hintText: 'Name',
                    icon: Icons.person,
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Email Address',
                    icon: Icons.email,
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    textEditingController: _oldPasswordController,
                    hintText: 'Old Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    textEditingController: _newPasswordController,
                    hintText: 'New Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    textEditingController: _phoneController,
                    hintText: 'Phone Number',
                    icon: Icons.phone,
                    obscureText: false,
                  ),
                  const SizedBox(height: 32),
                  Button(
                    text: 'Update Profile',
                    onTap: _updateProfile,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
