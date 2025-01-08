import 'package:flutter/material.dart';
import 'package:fyp/screens/search_product.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Open the search delegate
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(category: "All"), // Default category
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Search for products!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
