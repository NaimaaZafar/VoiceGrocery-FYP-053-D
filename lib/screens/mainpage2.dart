import 'package:flutter/material.dart';
import 'package:fyp/screens/exclusive_deals.dart';
import 'package:fyp/widgets/button.dart';

class MainPage2 extends StatefulWidget {
  const MainPage2({super.key});

  @override
  State<MainPage2> createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  void navigateToCategoryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DealsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              "asset/img_1.png",
              height: 350,
              width: 400,
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Delivering groceries \n under 15 minutes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Explore and order your favorite \n grocery items",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Button(
              text: "EXPLORE",
              onTap: navigateToCategoryScreen,
            ),
          ],
        ),
      ),
    );
  }
}
