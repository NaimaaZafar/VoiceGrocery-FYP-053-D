import 'package:flutter/material.dart';
import 'package:fyp/utils/food_menu.dart'; // Ensure this file has your Restaurant class and related models.
import 'package:fyp/widgets/product_cards.dart';

class CategoryContent extends StatelessWidget {
  final String category;

  const CategoryContent({super.key, required this.category});

  Future<List<Food>> _fetchCategoryItems() async {
    final restaurant = Restaurant();
    await restaurant.fetchFoodMenu();
    return restaurant.foodMenu.where((item) {
      return item.category.name.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: _fetchCategoryItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No items found in $category',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          final filteredItems = snapshot.data!;
          return Container(
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ProductCard(
                  food: item,
                );
              },
            ),
          );
        }
      },
    );
  }
}
