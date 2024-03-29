import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nisoko_vendors/controllers/landing-controller.dart';
import 'package:nisoko_vendors/controllers/stores-controller.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'package:nisoko_vendors/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

SizedBox sideBar(BuildContext context){
  LandingController landingController = Get.put(LandingController());
  return SizedBox(
    width: 200,
    child: Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(child: MoveWindow())
              ],
            ),
          ),
          Obx(() {
      final userDetails = Get.find<LandingController>().userdetails.value;

      if (userDetails.isNotEmpty && userDetails['success']) {
        return ClipOval(
          child: FadeInImage(
            placeholder: AssetImage('assets/placeholder.png'), // Placeholder image
            image: CachedNetworkImageProvider(
              userDetails['data']['avatar'],
            ),
            fit: BoxFit.cover,
            width: 80.0,
            height: 80.0,
          ),
        );
      } else {
        return CircularProgressIndicator(); // Show CircularProgressIndicator while data is loading
      }
    }),
          Container(
            height: 300,
            child: Column(
              children: [
                Divider(height: 1,color: Colors.black,),
                TextButton(
                  onPressed: (){},
                  child: Row(
                    children: [
                      Icon(Icons.store_mall_directory_outlined, color: AppTheme.backgroundColor,),
                      Text("Stores", style: TextStyle(color: AppTheme.backgroundColor),)
                    ],
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
                Divider(height: 1,color: Colors.black,),
                TextButton(
                  onPressed: (){},
                  child: Row(
                    children: [
                      Icon(Icons.person_2_rounded, color: AppTheme.backgroundColor,),
                      Text("Account", style: TextStyle(color: AppTheme.backgroundColor),)
                    ],
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
                Divider(height: 1,color: Colors.black,),
                TextButton(
                  onPressed: (){},
                  child: Row(
                    children: [
                      Icon(Icons.notifications, color: AppTheme.backgroundColor,),
                      Text("Notifications", style: TextStyle(color: AppTheme.backgroundColor),)
                    ],
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
                Divider(height: 1,color: Colors.black,),
                SizedBox(height: 20,),
                Container(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: (){
                      logout(context);
                    }, 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.power_settings_new_outlined),
                        Text("Logout")
                      ],
                    ),
                    style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => AppTheme.backgroundColor),
                    foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  ),
                )
                          
              ],
            ),
          )

        ],
      ),
    ),
  );
}

Widget getPage(String page) {
    switch (page) {
      case 'Account':
        return Text('account Page', style: TextStyle(color: Colors.white),);
      case 'Stores':
        return Text('stores', style: TextStyle(color: Colors.white),);
      case 'Notifications':
        return Text('Notifications', style: TextStyle(color: Colors.white),);
      case 'Notifications':
        return Text('Notifications', style: TextStyle(color: Colors.white),);
      // Add more cases for additional pages
      default:
        return Text('Invalid Page', style: TextStyle(color: Colors.white),);
    }
  }

Widget createShadowedContainer({
  required double height,
  required double width,
  required Color color,
  required Widget child,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.5), // Adjust opacity as needed
          spreadRadius: 8,
          blurRadius: 7,
          offset: Offset(0, 0), // changes position of shadow (right and bottom)
        ),
      ],
    ),
    child: Center(
      child: child,
    ),
  );
}

Widget ButtonContainer({
  required IconData icon,
  required VoidCallback onPressed,
}){
  return Container(
    margin: EdgeInsets.only(top: 2, bottom: 2,left: 1, right: 1),
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      color: Color.fromARGB(255, 14, 5, 77),
    ),
    child: InkWell(
      onTap: onPressed, 
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20,)
        ],
      )
    ),
  );
}

void openSelectStoreDialog(BuildContext context) async {
  StoresController storesController = Get.put(StoresController());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String selectedStoreJson = prefs.getString('selectedStore') ?? '';
  Map<String, dynamic>? selectedStore = selectedStoreJson.isNotEmpty ? jsonDecode(selectedStoreJson) : null;
  Map<String, dynamic> stores = storesController.Stores.value; // Replace with your list of stores

  showDialog(
    context: context,    
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 10,
        backgroundColor: AppTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select a Store', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Container(
          width: 300,
          height: 250, 
          // Adjust height as needed
          child: ListView.builder(
            itemCount: stores['data'].length,
            itemBuilder: (BuildContext context, int index) {
              final storeName = stores["data"][index]['storename'];
              final storeId = stores["data"][index]['_id'];
              return RadioListTile<String>(
                title: Text(storeName, style: TextStyle(color: Colors.white)),                
                activeColor: AppTheme.mainColor,                 
                value: storeId,
                groupValue: selectedStore != null && selectedStore['_id'] == storeId ? storeId : null,
                onChanged: (value) async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  final selectedStoreJson = jsonEncode(stores['data'][index]);
                  await prefs.setString('selectedStore', selectedStoreJson);
                  storesController.selectedStore.value = selectedStoreJson;
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      );
    },
  );
}



Future<void> showProductAddDialog(BuildContext context) async {
  int currentPage = 0;

  final PageController controller = PageController(initialPage: currentPage);
  final StoresController storesController = Get.put(StoresController());

  void goToNextPage() {
    if (storesController.currentPage.value < 7) {
      storesController.currentPage.value++;
      controller.animateToPage(
        storesController.currentPage.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    if (storesController.currentPage.value > 0) {
      storesController.currentPage.value--;
      controller.animateToPage(
        storesController.currentPage.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.all(1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
        content: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.mainColor,
                AppTheme.backgroundColor,
              ]
            )
          ),
          height: 400,
          width: 500,
          child: Stack(
            children: [
              Form(
                child: PageView(
                controller: controller,
                onPageChanged: (int page) {
                  storesController.currentPage.value = page;
                },
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white, width: 1), // Specify the border color here
                          ),
                          labelText: "Product Name", 
                          labelStyle: TextStyle(color: Colors.white),  
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white, width: 1), // Specify the border color here
                          ),
                          labelText: "Brand", 
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.white),  
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white, width: 1), // Specify the border color here
                          ),
                          labelText: "Category", 
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.white),  
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white, width: 1), // Specify the border color here
                          ),
                          labelText: "Subcategory", 
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.white),  
                        ),
                      )

                    ],
                  ),
                  Center(child: Text("two"),),
                  Center(child: Text("three"),),
                  Center(child: Text("four"),),
                  Center(child: Text("five"),),
                  Center(child: Text("six"),),
                  Center(child: Text("seven"),),
                  Center(child: Text("eight"),),






                ],
                              ),
        
              ),
        
              Positioned(
                top: 0,
                right: 0,
                child:  IconButton(
                  icon: Icon(Icons.close_sharp),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ),
            ],
          ),
        ),
        actions: [
          Obx(() => storesController.currentPage.value != 0
              ? TextButton(
              onPressed: goToPreviousPage, child: Text("Previous"))
              : Container()),
          
              Obx(() => storesController.currentPage.value != 7 ? TextButton(
              onPressed: goToNextPage, child: Text("Next"))
              : Container())
        ],
      );
    },
  );
}
mainWindow(){
  return Container(
    color: Colors.white,
    child: Row(
      children: [
        WindowTitleBarBox(
          child: Row(
            children: [
              Expanded(child: MoveWindow())
            ],
          ),
        )
  
      ],
    ),
  );
}