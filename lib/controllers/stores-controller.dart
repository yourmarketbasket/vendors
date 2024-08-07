import "dart:convert";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:get/get_rx/get_rx.dart";
import "package:nisoko_vendors/utils/constants.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:http/http.dart' as http;
class StoresController extends GetxController{
  RxMap<String, dynamic> Stores = Map<String, dynamic>().obs;
  RxString selectedStore = "".obs;
  RxString storeproducts = "".obs;
  RxString storeorders = "".obs;
  var  zoom = 15.0.obs;

  RxMap<String, dynamic> product = Map<String, dynamic>().obs;
  RxInt sliderIndex = 0.obs;

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
      await getStoreOrders(storeid);
    }

  }
Future<Map<String, dynamic>> editStoreProductDetails(Map<String, dynamic> data) async {
  final String serverLink = '${Constants.serverLink}/api/products/editStoreProductDetails';

  try {
    final http.Response response = await http.post(
      Uri.parse(serverLink),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    final statusCode = response.statusCode;
    final responseData = jsonDecode(response.body);

    if (statusCode == 200) {
      if(responseData['success']){
        return responseData;
      }else{
        throw Exception('Error one: ${responseData['message']}');
      }
    } else {
      throw Exception('Operation Failed: ${responseData['message']}');
    }
  } catch (error) {
    return {'message': 'Error two: ${error}', 'success': false};
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
      await getStoreOrders(storeid);

    } else {
      // If no products found, clear the store products
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('storeProducts');
      storeproducts.value = ""; 
      await getStoreOrders(storeid);
      // or set to any default value as needed
    }
  }
}
// create a function to remove or delete a product
Future<void> deleteProduct(String productId) async {
  if (productId != null) {
    final String serverLink = '${Constants.serverLink}/api/products/deleteProduct/${productId}';
    try {
      final http.Response response = await http.delete(
        Uri.parse(serverLink),
        headers: {'Content-Type': 'application/json'},
      );

      final statusCode = response.statusCode;
      final responseData = jsonDecode(response.body);

      if (statusCode == 200) {
        if (responseData['success']) {
          // Product deleted successfully
          // Perform any additional actions if needed
        } else {
          throw Exception('Error: ${responseData['message']}');
        }
      } else {
        throw Exception('Operation Failed: ${responseData['message']}');
      }
    } catch (error) {
      throw Exception('Error: ${error}');
    }
  }
}
Future<void> getStoreOrders(String storeid) async {
  if (storeid != null) {
    http.Response response = await http.get(
      Uri.parse('${Constants.serverLink}/api/products/groupAllStoreOrders/${storeid}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
      // Parse the JSON response body
      Map<String, dynamic> responseJson = jsonDecode(response.body);

      // Convert the response JSON to a string
      String productsJson = jsonEncode(responseJson['orders']);

      // Store the products JSON string in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Remove existing store products string
      await prefs.remove('storeOrders');

      // Set the new store products JSON string in SharedPreferences
      await prefs.setString('storeOrders', productsJson);

      // Update the value in the controller
      storeorders.value = productsJson;
      
    } else {
      // If no products found, clear the store products
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('storeOrders');
      storeorders.value = ""; // or set to any default value as needed
    }
  }
}





  
}