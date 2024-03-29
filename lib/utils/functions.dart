
import 'package:flutter/material.dart';
import 'package:nisoko_vendors/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

logout(BuildContext context) async {
            // Delete user ID from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("userid");
  

  // Navigate to login screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
 
}

String formatNumber(num number) {
  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1)}b';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}m';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}k';
  } else {
    return number.toString();
  }
}
