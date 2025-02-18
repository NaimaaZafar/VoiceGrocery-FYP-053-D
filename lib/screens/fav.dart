import 'package:flutter/material.dart';
import 'package:fyp/screens/cart_fav_provider.dart';
import 'package:fyp/screens/category.dart';
import 'package:fyp/screens/profile.dart';
import 'package:fyp/screens/settings.dart';
import 'package:fyp/widgets/navbar.dart';
import 'package:fyp/widgets/product_cards.dart';
import 'package:provider/provider.dart';

import '../utils/food_menu.dart';


class FavScreen extends StatefulWidget {
  final int initialIndex;

  const FavScreen({super.key, this.initialIndex = 0});

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  int _selectedIndex = 1;

  // function to remove duplicates items from the favorite list
  List<Food> removeDuplicates(List<Food> list) {
    List<Food> newList = [];
    for (var item in list) {
      if (!newList.contains(item)) {
        newList.add(item);
      }
    }
    return newList;
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Using Navigator to push replacement
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CategoryScreen(categoryName: 'MeatsFishes')),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FavScreen()),
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
    }
  }

  @override
  Widget build(BuildContext context) {

    // Remove duplicates
    final favoriteItems = removeDuplicates(Provider.of<CartFavoriteProvider>(context).favoriteItems);

    // calling the function each time the screen is built
    removeDuplicates(favoriteItems);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B57B2),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        // checking ig the item is in favorite then making color red
        title: Text('Favorites', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const CategoryScreen(categoryName: 'MeatsFishes'),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: favoriteItems.isEmpty
          ? Center(child: Text('No favorite items yet.'))
          : ListView.builder(
        // making the list unique so that there are no duplicates

        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          return ProductCard(food: favoriteItems[index]); // Pass food object
        },
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}