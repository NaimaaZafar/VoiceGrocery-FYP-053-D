import 'package:flutter/material.dart';
import 'package:fyp/utils/food_menu.dart';


class CartFavoriteProvider extends ChangeNotifier {
  final List<Food> _favoriteItems = [];
  final List<Food> _cartItems = [];

  List<Food> get favoriteItems => _favoriteItems;
  List<Food> get cartItems => _cartItems;

  // Get the quantity of a food item in the cart
  int getQuantity(Food food) {
    final existingFood = _cartItems.firstWhere(
          (item) => item.name == food.name,
      orElse: () => Food(name: '', descriptions: {}, imagePath: '', price: 0, category: FoodCategory.MeatsFishes, quantity: 0),
    );
    return existingFood.quantity;
  }

  // Add to favorites
  void addToFavorites(Food food) {
    if (!_favoriteItems.contains(food)) {
      _favoriteItems.add(food);
      notifyListeners();
    }
  }

  // Remove from favorites
  void removeFromFavorites(Food food) {
    _favoriteItems.remove(food);
    notifyListeners();
  }

  // Cart Management
  void addToCart(Food food) {
    // Check if the item is already in the cart
    var existingFood = _cartItems.firstWhere(
          (item) => item.name == food.name,
      orElse: () => Food(name: '', descriptions: {}, imagePath: '', price: 0, category: FoodCategory.MeatsFishes, quantity: 0),
    );

    if (existingFood.name == '') {
      // If not in cart, add it with quantity 1
      food.quantity = 1; // Set quantity to 1
      _cartItems.add(food);
    } else {
      // If in cart, increase quantity
      existingFood.quantity++;
    }
    notifyListeners(); // Notify listeners to update the UI
  }

  void removeFromCart(Food food) {
    _cartItems.removeWhere((item) => item.name == food.name);
    notifyListeners(); // Notify listeners to update the UI
  }

  void increaseQuantity(Food food) {
    var existingFood = _cartItems.firstWhere(
          (item) => item.name == food.name,
      orElse: () => Food(name: '', descriptions: {}, imagePath: '', price: 0, category: FoodCategory.MeatsFishes, quantity: 0),
    );

    if (existingFood.name != '') {
      existingFood.quantity++; // Increase quantity
      notifyListeners();
    }
  }

  void decreaseQuantity(Food food) {
    var existingFood = _cartItems.firstWhere(
          (item) => item.name == food.name,
      orElse: () => Food(name: '', descriptions: {}, imagePath: '', price: 0, category: FoodCategory.MeatsFishes, quantity: 0),
    );

    if (existingFood.name != '' && existingFood.quantity > 1) {
      existingFood.quantity--; // Decrease quantity
      notifyListeners();
    } else if (existingFood.name != '' && existingFood.quantity == 1) {
      removeFromCart(food); // Remove item if quantity reaches 0
    }
  }
}