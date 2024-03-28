import "dart:convert";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:nisoko_vendors/utils/constants.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:http/http.dart' as http;
class StoresController extends GetxController{
  RxMap<String, dynamic> Stores = Map<String, dynamic>().obs;
  RxString selectedStore = "".obs;
  RxString storeproducts = "".obs;

  RxInt currentPage = 0.obs;

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

  void getSelectedStore() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? store = prefs.getString("selectedStore");
    if(store!=null){
      selectedStore.value = store;
      final storeid = jsonDecode(selectedStore.value)['_id'];
      await getStoreProducts(storeid);
    }

  }

 Future<void> getStoreProducts(String storeid) async {
  if (storeid != null) {
    http.Response response = await http.get(
      Uri.parse('${Constants.serverLink}/api/products/getProductsByStore/${storeid}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
      // Parse the JSON response body
      Map<String, dynamic> responseJson = jsonDecode(response.body);

      // Convert the response JSON to a string
      String productsJson = jsonEncode(responseJson['data']);

      // Store the products JSON string in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Remove existing store products string
      await prefs.remove('storeProducts');

      // Set the new store products JSON string in SharedPreferences
      await prefs.setString('storeProducts', productsJson);

      // Update the value in the controller
      storeproducts.value = productsJson;
    } else {
      // If no products found, clear the store products
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('storeProducts');
      storeproducts.value = ""; // or set to any default value as needed
    }
  }
}





  
}