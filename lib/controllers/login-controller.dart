import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisoko_vendors/screens/landing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginController {
  String userId = "";
  RxString feedback = "".obs;
  RxBool error = false.obs;

  // Constructor
  LoginController() {
    setUserId();
  }

  // Method to set user ID from SharedPreferences
  Future<void> setUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userIdFromPrefs = sharedPreferences.getString("userid");

    if (userIdFromPrefs != null && userIdFromPrefs.isNotEmpty) {
      userId = userIdFromPrefs;
    }
  }

  // Method to perform user login
  Future<Map<String, dynamic>> loginUser(BuildContext context, Map<String, dynamic> userData) async {
    // Define the URL for the server
    final String url = 'http://localhost:3000/api/users/login';

    // Simulate sending user data to a server and receiving a response
    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(userData),
      headers: {'Content-Type': 'application/json'},
    );

    // Check if the response status code indicates success
    if (response.statusCode == 200) {
      // Parse the JSON response body
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      feedback.value = responseJson['message'];
      error.value = false;

      // Save user ID into SharedPreferences
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("userid", responseJson['userid']);

      // Navigate to LandingScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingScreen()),
      );

      // Return the response data as a map
      return responseJson;
    } else {
      error.value = true;
      feedback.value = jsonDecode(response.body)['message'];

      // Return an empty map if the response status code indicates failure
      return {};
    }
  }
}
