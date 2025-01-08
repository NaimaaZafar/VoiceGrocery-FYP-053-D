import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget{
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  final bool obscureText;

  const TextFieldInput({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.icon,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: textEditingController,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black45,
            fontSize: 18,
          ),
          prefixIcon: Icon(
            icon ,
            color: Colors.black45,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(30)
          ),
        ),
      ),
    );
  }
}