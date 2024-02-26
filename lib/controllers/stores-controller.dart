import "dart:convert";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:nisoko_vendors/utils/constants.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:http/http.dart' as http;
class StoresController{
  RxMap<String, dynamic> Stores = Map<String, dynamic>().obs;
  RxString selectedStore = "".obs;

  void getStores() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString("userid");
    if(userid !=null){
      http.Response response = await http.get(
        Uri.parse('${Constants.serverLink}/getStores/${userid}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
      // Parse the JSON response body
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        Stores.value = responseJson;
      } 
    }

  }
  
}