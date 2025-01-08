import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  const MyDrawerTile({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(text, style: TextStyle(color: Colors.black),),
    leading: Icon(
      icon,
      color: Colors.grey,
    ),
      onTap: onTap,
    );
  }
}