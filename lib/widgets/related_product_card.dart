import 'package:flutter/material.dart';

class RelatedProduct extends StatefulWidget {
  final String name;
  final String price;
  final String imagePath;

  const RelatedProduct({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  @override
  State<RelatedProduct> createState() => _RelatedProductState();
}

class _RelatedProductState extends State<RelatedProduct> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, // Restrict the width to avoid overflow in horizontal lists
      child: Card(
        margin: const EdgeInsets.only(right: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: GestureDetector(
          onTap: () {
            // Handle tap action here (e.g., navigate to product details)
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.asset(
                  widget.imagePath,
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1, // Restrict text to a single line
                      overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
