import 'package:flutter/material.dart';
import 'package:fyp/utils/category_content.dart';

class ProductSearchDelegate extends SearchDelegate {
  final String category;

  ProductSearchDelegate({required this.category});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filter the products based on the query and category
    return CategoryContent(category: category);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions if needed, here we'll show all products of the category
    return CategoryContent(category: category);
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }
}