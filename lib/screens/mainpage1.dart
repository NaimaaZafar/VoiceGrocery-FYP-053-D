import 'package:flutter/material.dart';

import 'mainpage2.dart';

class MainPage1 extends StatefulWidget {
  const MainPage1({super.key});

  @override
  State<MainPage1> createState() => _MainPage1State();
}

class _MainPage1State extends State<MainPage1> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration for one full rotation
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              "asset/img.png",
              height: 350,
              width: 400,
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Order your Groceries \n from your phone",
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
                "Now you can get groceries item at \n your doorstep",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 35),
            CustomLoadingIcon(animationController: _animationController),
          ],
        ),
      ),
    );
  }
}

class CustomLoadingIcon extends StatelessWidget {
  final AnimationController animationController;

  const CustomLoadingIcon({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Rotating progress indicator
        SizedBox(
          width: 80,
          height: 80,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: animationController.value * 2 * 3.141592653589793, // Full rotation
                child: child,
              );
            },
            child: const CircularProgressIndicator(
              strokeWidth: 4,
              color: Colors.green, // Green arc color
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        // Circular button with arrow, wrapped in GestureDetector
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainPage2()),
            );
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber, // Background color of the circle
            ),
            child: const Icon(
              Icons.arrow_forward, // Arrow icon
              size: 30,
              color: Colors.black, // Arrow icon color
            ),
          ),
        ),
      ],
    );
  }
}

//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:fyp/screens/login.dart';
// import 'package:fyp/utils/colors.dart';
// import 'package:lottie/lottie.dart';
//
// class VirtualGuidescreen extends StatefulWidget {
//   @override
//   State<VirtualGuidescreen> createState() => _VirtualGuidescreenState();
// }
//
// class _VirtualGuidescreenState extends State<VirtualGuidescreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     // Timer to navigate after 30 seconds
//     Timer(const Duration(seconds: 05), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen(onTap: null)),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bg_dark,
//       body: Center(
//         child: LottieBuilder.asset(
//           'asset/animation.json',
//           height: 300, // Adjust height to fit the screen
//           width: 300,  // Adjust width to fit the screen
//           repeat: true, // Ensure the animation loops
//         ),
//       ),
//     );
//   }
// }