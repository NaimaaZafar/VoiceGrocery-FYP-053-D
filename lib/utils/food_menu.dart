import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum FoodCategory {
  MeatsFishes,
  FreshVegetables,
  FreshFruits,
  Snacks,
  BrookiBakery,
}

class Food {
  final String name;
  final Map<String, String> descriptions;
  final String imagePath;
  final int price;
  final FoodCategory category;
  bool isFavorite;
  int quantity;

  Food({
    required this.name,
    required this.descriptions,
    required this.imagePath,
    required this.price,
    required this.category,
    this.isFavorite = false,
    this.quantity = 0,
  });

  static FoodCategory check(String s) {
    if (s == "FreshFruits") {
      return FoodCategory.FreshFruits;
    } else if (s == "FreshVegetables") {
      return FoodCategory.FreshVegetables;
    } else if (s == "MeatsFishes") {
      return FoodCategory.MeatsFishes;
    } else if (s == "Snacks") {
      return FoodCategory.Snacks;
    } else if (s == "BrookiBakery") {
      return FoodCategory.BrookiBakery;
    } else {
      throw ArgumentError("Invalid food category: $s");
    }
  }

  Food.fromMap(Map<dynamic, dynamic> res)
      : name = res['name'],
        descriptions = Map<String, String>.from(res['descriptions']),
        imagePath = res['imagePath'],
        price = res['price'],
        category = Food.check(res['category']),
        quantity = res['quantity'],
        isFavorite = res['Fav'];

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'descriptions': descriptions,
      'imagePath': imagePath,
      'price': price,
      'category': category.index,
      'quantity': quantity,
      'isFavorite': isFavorite,
    };
  }

  String getDescription(String locale) {
    return descriptions[locale] ?? descriptions['en']!;
  }
}

class Restaurant {
  final List<Food> foodMenu = [];

  List<Food> get menu => foodMenu;

  Future<void> fetchFoodMenu() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      final List<QueryDocumentSnapshot> documents = snapshot.docs;

      for (var doc in documents) {
        final data = doc.data() as Map<String, dynamic>;
        final food = Food.fromMap(data);
        foodMenu.add(food);
      }

      print(
        'Successfully fetched ${foodMenu.length} food items from Firestore.',
      );
    } catch (e) {
      print('Error fetching food menu: $e');
    }
  }

  // Function to update 'Fav' in each
  void updateFavorites(List<String> favoriteNames) {
    for (var food in foodMenu) {
      food.isFavorite = favoriteNames.contains(food.name);
    }
  }
}

class Cart {
  final List<Food> _items = [];

  void addItem(Food food) {
    if (food.quantity > 0) {
      _items.add(food);
      food.quantity--;
    } else {
      print("Item is out of stock: ${food.name}");
    }
  }

  void removeItem(Food food) {
    if (_items.remove(food)) {
      food.quantity++;
    }
  }

  int get totalItems => _items.length;

  double get totalPrice => _items.fold(0, (total, item) => total + item.price);

  void clearCart() {
    for (var item in _items) {
      item.quantity++;
    }
    _items.clear();
  }

  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's yours receipt");
    receipt.writeln();

    String formattedDate = DateFormat(
      'yyyy-MM-dd HH:mm-ss',
    ).format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("---------------------");

    for (final cartItem in _items) {
      receipt.writeln("${cartItem.quantity} x ${cartItem.name}");
      receipt.writeln();
    }

    receipt.writeln("---------------------");
    receipt.writeln();
    receipt.writeln("Total Items: $totalItems");
    receipt.writeln("Total Price: $totalPrice");

    return receipt.toString();
  }

  String generateReceipt() {
    if (_items.isEmpty) return "Your cart is empty!";
    final receipt = _items.map((item) {
      return "${item.name} - \$${item.price.toStringAsFixed(2)}";
    }).join("\n");
    return "$receipt\n\nTotal: \$${totalPrice.toStringAsFixed(2)}";
  }
}

void main() {
  final restaurant = Restaurant();
  final cart = Cart();

  cart.addItem(restaurant.menu[0]); // Big & Small Fishes
  cart.addItem(restaurant.menu[1]); // Halal Meat

  print("Total Items: ${cart.totalItems}");
  print("Total Price: \$${cart.totalPrice.toStringAsFixed(2)}");

  print("\nReceipt:\n${cart.generateReceipt()}");

  cart.clearCart();
  print("\nCart cleared.");
  print("Total Items after clearing: ${cart.totalItems}");
}
