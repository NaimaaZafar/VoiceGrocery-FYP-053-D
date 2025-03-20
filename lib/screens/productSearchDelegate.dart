import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductSearchDelegate extends SearchDelegate {
  final String category;

  ProductSearchDelegate({required this.category});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search query
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var results = snapshot.data!.docs;

        if (results.isEmpty) {
          return const Center(child: Text("No products found."));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            var product = results[index];
            return ListTile(
              title: Text(product['name']),
              subtitle: Text("Price: ${product['price']}"),
              leading: product['image'] != null
                  ? Image.network(product['image'], width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.image_not_supported),
              onTap: () {
                // Navigate to product details or add to cart
              },
            );
          },
        );
      },
    );
  }
}
