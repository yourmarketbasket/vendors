import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisoko_vendors/screens/landing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LandingController {
  RxString userId = "".obs;
  RxString feedback = "".obs;
  RxBool error = false.obs;
  RxString currentPage = "".obs;

RxMap<String, dynamic> userdetails = Map<String, dynamic>().obs;


  // Constructor
  LandingController() {
    setUserId();
  }

  // Method to set user ID from SharedPreferences
  Future<void> setUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userIdFromPrefs = sharedPreferences.getString("userid");

    if (userIdFromPrefs != null && userIdFromPrefs.isNotEmpty) {
      userId.value = userIdFromPrefs;
    }
  }

  getUserDetails() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userIdFromPrefs = sharedPreferences.getString("userid");

    if (userIdFromPrefs != null && userIdFromPrefs.isNotEmpty) {
      userId.value = userIdFromPrefs;
      // get the data from the database
      final String url = 'http://localhost:3000/getUser/${userId.value}';

      // Simulate sending user data to a server and receiving a response
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
      // Parse the JSON response body
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        userdetails.value = responseJson;
      } 

    }
  }


}
