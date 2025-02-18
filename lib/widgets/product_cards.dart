import 'package:flutter/material.dart';
import 'package:fyp/screens/item_details.dart';
import 'package:provider/provider.dart';
import 'package:fyp/screens/cart_fav_provider.dart'; // Import provider
import 'package:fyp/utils/food_menu.dart'; // Make sure to import the Food model

class ProductCard extends StatefulWidget {
  final Food food;

  const ProductCard({
    super.key,
    required this.food,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final cartFavoriteProvider = Provider.of<CartFavoriteProvider>(context);
    bool isFavorited = cartFavoriteProvider.favoriteItems.contains(widget.food);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsPage(
              title: widget.food.name,
              price: widget.food.price.toString(),
              image: widget.food.imagePath,
              description: widget.food.getDescription('en'),  // Pass description here
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Image.asset(widget.food.imagePath, width: 80, height: 80, fit: BoxFit.cover),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${widget.food.price}',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    // printing the isFavorited result
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isFavorited) {
                          cartFavoriteProvider.removeFromFavorites(widget.food);
                        } else {
                          // Checking if the item is not already present within the list then adding
                          if(cartFavoriteProvider.checkIfExist(widget.food)==false){
                            cartFavoriteProvider.addToFavorites(widget.food);
                          }
                        //  prints already added
                          else {
                            print('Already added');
                          }
                        }
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cartFavoriteProvider.addToCart(widget.food);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.food.name} added to cart')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}