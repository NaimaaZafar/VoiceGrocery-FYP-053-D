import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fyp/screens/cart_fav_provider.dart'; // Import your CartFavoriteProvider
import 'package:fyp/utils/food_menu.dart'; // Make sure you import the Food model

class ProductCardAddRemove extends StatelessWidget {
  final Food food;

  const ProductCardAddRemove({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    final cartFavoriteProvider = Provider.of<CartFavoriteProvider>(context);
    final quantity = cartFavoriteProvider.getQuantity(food); // Get the correct quantity

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image and details of the food
            Image.asset(food.imagePath, width: 80, height: 80, fit: BoxFit.cover),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text('\$${food.price}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        cartFavoriteProvider.decreaseQuantity(food); // Decrease quantity
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 14)),
                    IconButton(
                      onPressed: () {
                        cartFavoriteProvider.increaseQuantity(food); // Increase quantity
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    cartFavoriteProvider.removeFromCart(food); // Remove from cart
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}