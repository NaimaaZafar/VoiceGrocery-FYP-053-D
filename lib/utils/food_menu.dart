import 'package:intl/intl.dart';

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
  final double price;
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

  Food.fromMap(Map<dynamic, dynamic> res)
      : name = res['name'],
        descriptions = Map<String, String>.from(res['descriptions']),
        imagePath = res['imagePath'],
        price = res['price'],
        category = FoodCategory.values[res['category']],
        quantity = res['quantity'],
        isFavorite = res['isFavorite'];

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
  final List<Food> foodMenu = [
    // Meats and Fishes
    Food(
      name: 'Big & Small Fishes',
      descriptions: {
        'en': 'A fresh assortment of big and small fishes, perfect for grilling, frying, or making delicious seafood dishes.',
        'ur': 'بڑی اور چھوٹی مچھلیوں کا تازہ انتخاب، گرلنگ، فرائی یا مزیدار سمندری کھانے بنانے کے لیے بہترین۔',
      },
      imagePath: 'asset/fish.png',
      price: 2330,
      category: FoodCategory.MeatsFishes,
      quantity: 10,
    ),
    Food(
      name: 'Halal Meat',
      descriptions: {
        'en': 'Premium halal-certified meat, rich in flavor and ideal for a variety of dishes including curries, steaks, and barbeques.',
        'ur': 'پریمیم حلال گوشت، ذائقے میں بھرپور اور مختلف کھانوں کے لیے مثالی۔',
      },
      imagePath: 'asset/redmeat.png',
      price: 4590,
      category: FoodCategory.MeatsFishes,
      quantity: 5,
    ),
    // Fresh Vegetables
    Food(
      name: 'Red & Green Chilli',
      descriptions: {
        'en': 'Fresh and spicy red and green chilies, perfect for adding heat and flavor to your dishes.',
        'ur': 'تازہ اور مصالحہ دار لال اور ہری مرچیں، آپ کے کھانوں کو ذائقہ دینے کے لیے بہترین۔',
      },
      imagePath: 'asset/chilli.png',
      price: 100,
      category: FoodCategory.FreshVegetables,
      quantity: 15,
    ),
    Food(
      name: 'Carrots',
      descriptions: {
        'en': 'Crisp and sweet carrots, ideal for salads, stews, or healthy snacking.',
        'ur': 'میٹھے اور کرارے گاجر، سلاد، سالن یا صحت مند ناشتے کے لیے بہترین۔',
      },
      imagePath: 'asset/carrot.png',
      price: 500,
      category: FoodCategory.FreshVegetables,
      quantity: 12,
    ),
    Food(
      name: 'Potato',
      descriptions: {
        'en': 'Versatile and fresh potatoes, great for fries, mashed potatoes, curries, and more.',
        'ur': 'ہر کام کے لیے بہترین تازہ آلو، فرائیز، سالن اور مزید کے لیے۔',
      },
      imagePath: 'asset/potato.png',
      price: 300,
      category: FoodCategory.FreshVegetables,
      quantity: 20,
    ),
    // Fresh Fruits
    Food(
      name: 'Fresh Apples',
      descriptions: {
        'en': 'Juicy and crisp apples, perfect for snacking, baking, or adding to salads.',
        'ur': 'مزے دار اور خستہ سیب، ناشتے، بیکنگ یا سلاد کے لیے بہترین۔',
      },
      imagePath: 'asset/apple.png',
      price: 300,
      category: FoodCategory.FreshFruits,
      quantity: 25,
    ),
    Food(
      name: 'Bananas',
      descriptions: {
        'en': 'Sweet and creamy bananas, a healthy and delicious snack for all ages.',
        'ur': 'میٹھے اور کریمی کیلے، ہر عمر کے لیے صحت مند اور مزیدار۔',
      },
      imagePath: 'asset/banana.png',
      price: 150,
      category: FoodCategory.FreshFruits,
      quantity: 30,
    ),
    Food(
      name: 'Oranges',
      descriptions: {
        'en': 'Refreshing and tangy oranges, packed with vitamin C for a nutritious treat.',
        'ur': 'تازگی بخش اور خوش ذائقہ مالٹے، وٹامن سی سے بھرپور۔',
      },
      imagePath: 'asset/orange.png',
      price: 250,
      category: FoodCategory.FreshFruits,
      quantity: 20,
    ),
    Food(
      name: 'Cherry',
      descriptions: {
        'en': 'Delicious and vibrant cherries, ideal for desserts or enjoying fresh.',
        'ur': 'لذیذ اور شاندار چیری، میٹھے یا تازہ کھانے کے لیے بہترین۔',
      },
      imagePath: 'asset/cherry.png',
      price: 1000,
      category: FoodCategory.FreshFruits,
      quantity: 20, // Example quantity
    ),
    Food(
      name: 'Watermelon',
      descriptions: {
        'en': 'Sweet and hydrating watermelon, perfect for hot summer days.',
        'ur': 'میٹھا اور ہائیڈریٹنگ تربوز، گرم موسم گرما کے دنوں کے لیے بہترین۔',
      },
      imagePath: 'asset/watermelon.png',
      price: 80,
      category: FoodCategory.FreshFruits,
      quantity: 15, // Example quantity
    ),
    Food(
      name: 'Guava',
      descriptions: {
        'en': 'Nutritious and flavorful guavas, packed with vitamin C and dietary fiber.',
        'ur': 'غذائیت سے بھرپور اور مزیدار امرود، وٹامن سی اور فائبر سے بھرے ہوئے۔',
      },
      imagePath: 'asset/guava.png',
      price: 120,
      category: FoodCategory.FreshFruits,
      quantity: 25, // Example quantity
    ),

    // Snacks
    Food(
      name: 'Chips Pack',
      descriptions: {
        'en': 'Crispy and flavorful potato chips, perfect for snacking on the go.',
        'ur': 'کرارے اور ذائقہ دار چپس، چلتے پھرتے ناشتے کے لیے بہترین۔',
      },
      imagePath: 'asset/chips.png',
      price: 50,
      category: FoodCategory.Snacks,
      quantity: 40,
    ),
    Food(
      name: 'Candy',
      descriptions: {
        'en': 'Sweet and colorful candies, a delightful treat for kids and adults.',
        'ur': 'میٹھے اور رنگ برنگے کینڈی، بچوں اور بڑوں کے لیے خوشی بخش۔',
      },
      imagePath: 'asset/candy.png',
      price: 30,
      category: FoodCategory.Snacks,
      quantity: 50,
    ),
    // Brooki Bakery
    Food(
      name: 'Biscuits',
      descriptions: {
        'en': 'Delicious and crunchy biscuits, perfect for pairing with tea or coffee.',
        'ur': 'مزیدار اور کرارے بسکٹ، چائے یا کافی کے ساتھ بہترین۔',
      },
      imagePath: 'asset/bakerybis.png',
      price: 100,
      category: FoodCategory.BrookiBakery,
      quantity: 35,
    ),
    Food(
      name: 'Butter',
      descriptions: {
        'en': 'Rich and creamy butter, ideal for spreading, baking, or cooking.',
        'ur': 'مالدار اور کریمی مکھن، پھیلانے، بیکنگ یا کھانے پکانے کے لیے بہترین۔',
      },
      imagePath: 'asset/butter.png',
      price: 400,
      category: FoodCategory.BrookiBakery,
      quantity: 10,
    ),
    Food(
      name: 'Cake',
      descriptions: {
        'en': 'Soft and spongy cake, perfect for celebrations or as a sweet treat.',
        'ur': 'نرم اور اسپونجی کیک، تقریبات یا میٹھے کے طور پر بہترین۔',
      },
      imagePath: 'asset/cake.png',
      price: 800,
      category: FoodCategory.BrookiBakery,
      quantity: 5,
    ),
  ];

  List<Food> get menu => foodMenu;
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

  double get totalPrice =>
      _items.fold(0, (total, item) => total + item.price);

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

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm-ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("---------------------");

    for (final cartItem in _items){
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
