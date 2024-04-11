import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nisoko_vendors/controllers/landing-controller.dart';
import 'package:nisoko_vendors/controllers/stores-controller.dart';
import 'package:nisoko_vendors/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nisoko_vendors/screens/landing.dart';
import 'package:nisoko_vendors/screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const EntryPage());
}

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  LandingController landingController = Get.put(LandingController());
  StoresController storesController = Get.put(StoresController());
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    landingController.getUserDetails();
    storesController.getStores();
    storesController.getSelectedStore();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nisoko Vendors',
      theme: ThemeData(
        fontFamily: "Poppins",
        scrollbarTheme: ScrollbarThemeData(
        thickness: MaterialStateProperty.all(2),
        thumbColor: MaterialStateProperty.all(Colors.green), // Change thumb color
        // You can also customize other properties such as thickness, radius, etc.
      ),
        // Your theme data
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkUserIdExists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a loading indicator or splash screen while checking userId existence
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle error
            return Text('Error: ${snapshot.error}');
          } else {
            // Navigate to appropriate screen based on userId existence
            if (snapshot.data == true) {
              return LandingScreen();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
    );
  }

  Future<bool> checkUserIdExists() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString("userid");
    return userId != null;
  }
}
