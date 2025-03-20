import 'package:flutter/material.dart';
import 'package:fyp/utils/checkoutDetails.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/utils/food_menu.dart';
import 'package:fyp/widgets/button.dart';
import 'package:fyp/widgets/product_card_add_remove.dart'; // Import your food model to work with

class CheckoutScreen extends StatelessWidget {
  final List<Food> selectedItems;

  const CheckoutScreen({super.key, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    double totalPrice = selectedItems.fold(0, (sum, item) => sum + item.price*item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout!', style: TextStyle(color: Colors.white),),
        backgroundColor: bg_dark,
      ),

      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ProductCardAddRemove(food: selectedItems[index]),
                    // child: ListTile(
                    //   title: Text(selectedItems[index].name),
                    //   subtitle: Text('Price: \$${selectedItems[index].price}'),
                    //   trailing: const Text('Qty: 1'),
                    // ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            Button(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutDetails()),
                );
              },
              text: 'Proceed to Checkout',
            ),
          ],
        ),
      ),
    );
  }
}
