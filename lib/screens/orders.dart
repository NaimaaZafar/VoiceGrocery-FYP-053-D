import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Text(
          "Your orders will be displayed here!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

