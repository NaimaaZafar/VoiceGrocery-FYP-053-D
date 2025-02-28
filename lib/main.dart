import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/firebase_options.dart';
import 'package:fyp/screens/splashscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:fyp/screens/cart_fav_provider.dart';
import 'package:fyp/utils/food_menu.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBining =
      WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  // Fetch food menu from firebase
  // final Rest = Restaurant();
  // await Rest.fetchFoodMenu();

  runApp(const VoiceGrocery());
}

class VoiceGrocery extends StatelessWidget {
  const VoiceGrocery({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartFavoriteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splashscreen(), // Your splash screen as the initial screen
      ),
    );
  }
}
