import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fyp/screens/cart_fav_provider.dart'; // Import your CartFavoriteProvider
import 'package:fyp/utils/food_menu.dart'; // Make sure you import the Food model
//
// class ProductCardAddRemove extends StatefulWidget {
//   final Food food; // Use Food object for easier access to all properties
//
//   const ProductCardAddRemove({
//     super.key,
//     required this.food,
//   });
//
//   @override
//   _ProductCardAddRemoveState createState() => _ProductCardAddRemoveState();
// }
//
// class _ProductCardAddRemoveState extends State<ProductCardAddRemove> {
//   late CartFavoriteProvider _cartFavoriteProvider;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _cartFavoriteProvider = Provider.of<CartFavoriteProvider>(context); // Initialize provider
//   }
//
//   int getQuantity() {
//     return _cartFavoriteProvider.getQuantity(widget.food); // Use CartFavoriteProvider's getQuantity method
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Container(
//         height: 120, // Adjusted card height
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             // Leading Image
//             Image.asset(widget.food.imagePath, width: 80, height: 80, fit: BoxFit.cover),
//
//             // Product Info Column
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.food.name,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       '\$${widget.food.price}',
//                       style: const TextStyle(color: Colors.grey, fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Quantity Control and Remove Icon
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 // Quantity Control Row
//                 Row(
//                   children: [
//                     // Decrement Button
//                     IconButton(
//                       onPressed: () {
//                         if (getQuantity() > 0) {
//                           _cartFavoriteProvider.decreaseQuantity(widget.food); // Use the Food object
//                         }
//                       },
//                       icon: const Icon(Icons.remove_circle_outline),
//                       color: Colors.grey,
//                     ),
//                     // Quantity Display
//                     Text(
//                       '${getQuantity()}',
//                       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                     // Increment Button
//                     IconButton(
//                       onPressed: () {
//                         _cartFavoriteProvider.increaseQuantity(widget.food); // Use the Food object
//                       },
//                       icon: const Icon(Icons.add_circle_outline),
//                       color: Colors.grey,
//                     ),
//                   ],
//                 ),
//
//                 // Remove Icon
//                 IconButton(
//                   onPressed: () {
//                     _cartFavoriteProvider.removeFromCart(widget.food); // Use the Food object
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('${widget.food.name} removed from cart')),
//                     );
//                   },
//                   icon: const Icon(Icons.delete_outline),
//                   color: Colors.red,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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