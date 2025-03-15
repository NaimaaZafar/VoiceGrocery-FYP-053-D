import 'package:flutter/material.dart';
import 'package:fyp/screens/cart_fav_provider.dart';
import 'package:fyp/screens/profile.dart';
import 'package:fyp/screens/category.dart';
import 'package:fyp/screens/fav.dart';
import 'package:fyp/screens/settings.dart';
import 'package:fyp/screens/checkout.dart';
import 'package:fyp/screens/voice_recognition.dart';
import 'package:fyp/widgets/navbar.dart';
import 'package:fyp/widgets/button.dart';
import 'package:provider/provider.dart';
import '../widgets/product_card_add_remove.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  int _selectedIndex = 0;

  // List to track whether an item is selected
  List<bool> selectedItems = [];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Using Navigator to push replacement
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CategoryScreen(categoryName: '')),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FavScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AccountsPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VoiceRecognitionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartFavoriteProvider = Provider.of<CartFavoriteProvider>(context);

    // Initialize selectedItems list if it's empty
    if (selectedItems.isEmpty) {
      selectedItems = List.generate(cartFavoriteProvider.cartItems.length, (index) => false);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B57B2),
        elevation: 0,
        title: const Text('My Cart', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CategoryScreen(categoryName: 'MeatsFishes')),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content displaying cart items
          cartFavoriteProvider.cartItems.isEmpty
              ? const Center(child: Text('Your cart is currently empty.', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
            itemCount: cartFavoriteProvider.cartItems.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white, // Set the card background color to white
                elevation: 2, // Optional: Adjust the elevation for the card shadow
                child: CheckboxListTile(
                  title: ProductCardAddRemove(food: cartFavoriteProvider.cartItems[index]),
                  value: selectedItems[index],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedItems[index] = value ?? false;
                    });
                  },
                ),
              );
            },
          ),
          // "Buy Now" Button
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: Button(
              onTap: () {
                // Filter the selected items
                final selectedFoods = cartFavoriteProvider.cartItems.where((food) {
                  final index = cartFavoriteProvider.cartItems.indexOf(food);
                  return selectedItems[index]; // Check if the item is selected
                }).toList();

                // Pass the selected items to the CheckoutScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutScreen(selectedItems: selectedFoods)),
                );
              },
              text: 'Buy Now',
            ),
          ),
          const SizedBox(height: 30),
          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomNavBar(
              currentIndex: _selectedIndex,
              onItemSelected: _onItemSelected,
            ),
          ),
        ],
      ),
    );
  }
}
