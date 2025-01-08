import 'package:flutter/material.dart';
import 'package:fyp/screens/payment_verification.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/widgets/button.dart';
import 'package:fyp/widgets/text_field.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}
//
class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cardHolderNameController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose(){
    cardNumberController.dispose();
    expiryDateController.dispose();
    cardHolderNameController.dispose();
    cvvController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_dark,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: bg_dark, // Consistent AppBar color
          title: const Text('Add Card', style: TextStyle(color: Colors.white)),
          elevation: 0, // Flat AppBar
        ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            TextFieldInput(
              textEditingController: cardNumberController,
              hintText: "Card Number",
              icon: Icons.credit_card,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              textEditingController: expiryDateController,
              hintText: "Expiry Date",
              icon: Icons.date_range,
              obscureText: false,
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              textEditingController: cardHolderNameController,
              hintText: "Card Holder Name",
              icon: Icons.person,
              obscureText: false,
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              textEditingController: cvvController,
              hintText: "CVV Number",
              icon: Icons.security,
              obscureText: true,
            ),

            const SizedBox(height: 25),
            Button(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentVerificationScreen()));
            },text: "PAY"),
          ],
        ),
      ),
    );
  }
}
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;
//
//   void userTappedPay() {
//     if (formKey.currentState!.validate()) {
//       showDialog(context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Confirm Payment"),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: [
//                 Text("Card Number: $cardNumber"),
//                 Text("Expiry Date: $expiryDate"),
//                 Text("Card Holder Name: $cardHolderName"),
//                 Text("CVV: $cvvCode"),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => PaymentVerificationScreen())
//             ), child: const Text("Yes")),
//             TextButton(onPressed: () => Navigator.pop(context
//             ), child: const Text("No")),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: bg_dark, // Consistent AppBar color
//         title: const Text('Add Card', style: TextStyle(color: Colors.white)),
//         elevation: 0, // Flat AppBar
//       ),
//       body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Credit card widget to display the card information
//               CreditCardWidget(
//                 cardNumber: cardNumber,
//                 expiryDate: expiryDate,
//                 cardHolderName: cardHolderName,
//                 cvvCode: cvvCode,
//                 showBackView: isCvvFocused,
//                 onCreditCardWidgetChange: (p0) {},
//               ),
//               const SizedBox(height: 20), // Add some spacing between widgets
//
//               // Credit card form to take user inputs
//               CreditCardForm(
//                 cardNumber: cardNumber,
//                 expiryDate: expiryDate,
//                 cardHolderName: cardHolderName,
//                 cvvCode: cvvCode,
//                 onCreditCardModelChange: (data) {
//                   setState(() {
//                     cardNumber = data.cardNumber;
//                     expiryDate = data.expiryDate;
//                     cardHolderName = data.cardHolderName;
//                     cvvCode = data.cvvCode; // Fix this line (it should update cvvCode)
//                   });
//                 },
//                 formKey: formKey,
//               ),
//
//               const SizedBox(height: 20), // Add spacing before the button
//
//               Button(onTap: userTappedPay, text: "PAY"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
