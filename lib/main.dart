import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nisoko_vendors/screens/landing.dart';
import 'package:nisoko_vendors/screens/login.dart';

void main() {
  runApp(const EntryPage());
}

class EntryPage extends StatelessWidget {
  const EntryPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nisoko Vendors',
      theme: ThemeData(
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
