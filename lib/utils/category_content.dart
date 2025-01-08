// import 'package:flutter/material.dart';
// import 'package:fyp/utils/food_menu.dart';
// import 'package:fyp/widgets/product_cards.dart';
// import 'package:provider/provider.dart';
//
// class CategoryContent extends StatelessWidget {
//   final String category;
//
//   const CategoryContent({super.key, required this.category});
//
//   // List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu){
//   //   return fullMenu.where((food) => food.category == category).toList();
//   // }
//   //
//   // List<Widget> getFoodInthisCategory(List<Food> fullMenu) {
//   //   return FoodCategory.values.map((category){
//   //     List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
//   //     return ListView.builder(
//   //       itemCount: categoryMenu.length,
//   //       physics: const NeverScrollableScrollPhysics(),
//   //       padding: EdgeInsets.zero,
//   //       itemBuilder: (context, index){
//   //         final food = categoryMenu[index];
//   //         return ProductCard(title: food.name, price: food.price, image: food.imagePath);
//   //       },
//   //     );
//   //   }
//   //   ).toList();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Text(
//             'Explore $category',
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           if (category == 'Meats & Fishes') ...[
//             const ProductCard(
//               title: 'Big & Small Fishes',
//               price: 'Rs 2330/KG',
//               image: 'asset/fish.png',
//             ),
//             const ProductCard(
//               title: 'Halal Meats',
//               price: 'Rs 4590/KG',
//               image: 'asset/redmeat.png',
//             ),
//           ] else if (category == 'Fresh Vegetables') ...[
//             const ProductCard(
//               title: 'Fresh Tomatoes',
//               price: 'Rs 100/KG',
//               image: 'asset/orange.png',
//             ),
//             const ProductCard(
//               title: 'Carrots',
//               price: 'Rs 120/KG',
//               image: 'asset/carrot.png',
//             ),
//             const ProductCard(
//               title: 'Potato',
//               price: 'Rs 120/KG',
//               image: 'asset/potato.png',
//             ),
//           ] else if (category == 'Fresh Fruits') ...[
//             const ProductCard(
//               title: 'Fresh Apples',
//               price: 'Rs 150/KG',
//               image: 'asset/apple.png',
//             ),
//             const ProductCard(
//               title: 'Bananas',
//               price: 'Rs 50/KG',
//               image: 'asset/banana.png',
//             ),
//             const ProductCard(
//               title: 'Oranges',
//               price: 'Rs 50/KG',
//               image: 'asset/orange.png',
//             ),
//             const ProductCard(
//               title: 'Cherry',
//               price: 'Rs 50/KG',
//               image: 'asset/cherry.png',
//             ),
//             const ProductCard(
//               title: 'Watermelon',
//               price: 'Rs 50/KG',
//               image: 'asset/watermelon.png',
//             ),
//             const ProductCard(
//               title: 'Guava',
//               price: 'Rs 50/KG',
//               image: 'asset/guava.png',
//             ),
//           ] else if (category == 'Snacks') ...[
//             const ProductCard(
//               title: 'Chips Pack',
//               price: 'Rs 200',
//               image: 'asset/chips.png',
//             ),
//             const ProductCard(
//               title: 'Candy',
//               price: 'Rs 120/KG',
//               image: 'asset/candy.png',
//             ),
//           ] else if (category == 'Brooki Bakery') ...[
//             const ProductCard(
//               title: 'Biscuits',
//               price: 'Rs 50',
//               image: 'asset/bakerybis.png',
//             ),
//             const ProductCard(
//               title: 'Butter',
//               price: 'Rs 80',
//               image: 'asset/butter.png',
//             ),
//             const ProductCard(
//               title: 'Cake',
//               price: 'Rs 80',
//               image: 'asset/cake.png',
//             ),
//           ]
//         ],
//       ),
//     );
//
//     // return Scaffold(
//     //   backgroundColor: Colors.white,
//     //   body: NestedScrollView(
//     //       headerSliverBuilder: (context, innerBoxIsScrolled) => [
//     //         Container(
//     //
//     //         )
//     //       ],
//     //       body: Consumer<Resturant>(
//     //         builder: (context, resturant, child) => ,
//     //       )
//     //   ),
//     // )
//   }
// }

import 'package:flutter/material.dart';
import 'package:fyp/utils/food_menu.dart'; // Ensure this file has your Restaurant class and related models.
import 'package:fyp/widgets/product_cards.dart';

class CategoryContent extends StatelessWidget {
  final String category;

  const CategoryContent({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Create an instance of the Restaurant class
    final restaurant = Restaurant();

    // Filter the food items based on the selected category
    final filteredItems = restaurant.foodMenu.where((item) {
      return item.category.name.toLowerCase() == category.toLowerCase();
    }).toList();

    return Container(
      color: Colors.white,
      child: filteredItems.isEmpty
          ? Center(
        child: Text(
          'No items found in $category',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return ProductCard(food: item,
          );
        },
      ),
    );
  }
}