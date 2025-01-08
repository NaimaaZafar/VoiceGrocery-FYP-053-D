import 'package:flutter/material.dart';
import 'package:fyp/screens/checkout.dart';
import 'package:fyp/screens/profile.dart';
import 'package:fyp/screens/mainpage1.dart';
import 'package:fyp/screens/my_cart.dart';
import 'package:fyp/screens/search.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/widgets/button.dart';
import 'package:fyp/widgets/navbar.dart';
import 'package:fyp/widgets/related_product_card.dart';

class ItemDetailsPage extends StatefulWidget {
  final String title;
  final String price;
  final String image;
  final String description;

  const ItemDetailsPage({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
  });

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  final int _selectedIndex = 0; // Selected index for BottomNavigationBar
  List<double> starStates = [0, 0, 0, 0, 0]; // State for stars (0: empty, 1: full)

  double get rating => starStates.reduce((a, b) => a + b); // Total rating

  void updateStarRating(int index) {
    setState(() {
      for (int i = 0; i < starStates.length; i++) {
        starStates[i] = i <= index ? 1 : 0; // Fill stars up to the clicked one
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
        backgroundColor: bg_dark,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to Cart
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCart()));
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white,),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.image,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                "Rs 350.00", // Static old price
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.price,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () => updateStarRating(index),
                                child: Icon(
                                  Icons.star,
                                  color: starStates[index] == 1
                                      ? Colors.orange // Fully filled
                                      : Colors.grey, // Empty
                                  size: 32,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${rating.toStringAsFixed(1)}/5", // Display rating with 1 decimal place
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Button(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyCart()),
                  );
                },
                text: 'Buy Now',
              ),
              const SizedBox(height: 20),
              const Text(
                "Product Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,  // Displays the product description
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ExpansionTile(
                title: const Text("Reviews"),
                children: const [Text("User reviews go here.")],
              ),
              const SizedBox(height: 20),
              const Text(
                "More Products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    RelatedProduct(
                      name: "Apple",
                      price: "Rs 300.00",
                      imagePath: "asset/apple.png",
                    ),
                    RelatedProduct(
                      name: "Orange",
                      price: "Rs 350.00",
                      imagePath: "asset/orange.png",
                    ),
                  ],
                ),
              ),
              // Button(onTap: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen()),
              //   );
              // }, text: 'Buy Now')
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomNavBar(
      //   currentIndex: _selectedIndex,
      //   onItemSelected: (index) {
      //     if (index != _selectedIndex) {
      //       setState(() {
      //         _selectedIndex = index;
      //       });
      //       if (index == 0) {
      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage1()));
      //       } else if (index == 1) {
      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SearchPage()));
      //       } else if (index == 2) {
      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AccountsPage())); // Fixed navigation
      //       }
      //     }
      //   },
      // ),
    );
  }
}