import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

Future<void> sendOrderConfirmationEmail() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  const String emailAPI = "https://your-backend.com/send-email"; // Replace with your API

  final response = await http.post(
    Uri.parse(emailAPI),
    body: {
      "email": user.email,
      "subject": "Your Order is Confirmed!",
      "message": "Your order has been placed successfully. Track it here: https://your-app.com/orders",
    },
  );

  if (response.statusCode == 200) {
    print("Email sent successfully!");
  } else {
    print("Failed to send email: ${response.body}");
  }
}
