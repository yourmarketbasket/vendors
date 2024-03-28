import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nisoko_vendors/controllers/landing-controller.dart';
import 'package:nisoko_vendors/controllers/stores-controller.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'package:nisoko_vendors/utils/widgets.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  List<String> _selectedItems = [];
  final ScrollController _scrollController = ScrollController();
  LandingController landingController = Get.put(LandingController());
  StoresController storesController = Get.put(StoresController());
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    final dw = window.physicalSize.width;
    final dh = window.physicalSize.height;

    return Obx((){
      final store = storesController.selectedStore.value.isNotEmpty ? jsonDecode(storesController.selectedStore.value) : null;   
      final storeProducts = storesController.storeproducts.value != null &&
                            storesController.storeproducts.value.isNotEmpty &&
                            storesController.storeproducts.value is String
                            ? jsonDecode(storesController.storeproducts.value)
                            : null;

                       

      return storesController.selectedStore.value.isNotEmpty ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

         Padding(
          padding: const EdgeInsets.only(left:20.0, right: 20, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  store != null ? store['storename'].toUpperCase() : "No Store Selected",
                                  style: TextStyle(
                                    color: store != null ? AppTheme.mainColor : AppTheme.dangerColor,
                                  ),
                                ),
                                Icon(
                                  store != null ? Icons.signal_cellular_alt : Icons.signal_cellular_connected_no_internet_0_bar,
                                  color: store != null ? AppTheme.mainColor : AppTheme.dangerColor,
                                  size: 20,
                                ),
                              ],
                            ),
                            Text(
                              store != null ? store['storetype'].toUpperCase() : "",
                              style: TextStyle(color: const Color.fromARGB(255, 147, 144, 144), fontSize: 10),
                            ),
                          ],
                        ),
                        ButtonContainer(icon: Icons.refresh_rounded, onPressed: (){}),                           
                      
                      ],
                    )
                        
                ],
              ),
              
              Row(
                children: [
                  Container(
                    width: 300,
                    height: 35,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5)
                      
                    ),
                    child: TextFormField(                      
                      controller: _searchController,
                      style: TextStyle(color: Colors.white, fontSize: 12), 
                    
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.white),
                        
                      ),                 
                    
                    ),
                  ),
                  SizedBox(width: 5,),
                  ElevatedButton(
                    onPressed: (){}, 
                    child: Icon(Icons.search, color: Colors.white,),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      backgroundColor: AppTheme.mainColor,                          
                      
                    )
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  storeProducts!=null ? Container(
                    height: 0.6*dh,
                    width: 0.3*dw,
                    child: ListView.builder(
                      itemCount: storeProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final productName = storeProducts[index]['name'] ?? ''; // Ensure product name is not null
                        final isSelected = _selectedItems.contains(productName);

                        return CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding as needed
                          title: Text(
                            productName,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value != null) {
                              setState(() {
                                if (value) {
                                  _selectedItems.add(productName);
                                } else {
                                  _selectedItems.remove(productName);
                                }
                              });
                            }
                          },
                          controlAffinity: ListTileControlAffinity.leading, // Place the checkbox to the left of the title
                          activeColor: AppTheme.mainColor, // Customize the checkbox color as needed
                          secondary: isSelected // Show delete and edit icons if checkbox is selected
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.white),
                                      onPressed: () {
                                        // Handle edit action
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.white),
                                      onPressed: () {
                                        // Handle delete action
                                      },
                                    ),
                                  ],
                                )
                              : null, // Hide icons if checkbox is not selected
                        );
                      },
                    ),
                  ): Expanded(child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("No products in ${store['storename'].toUpperCase()}", style: TextStyle(color: Colors.white),),
                    ],
                  )))
                ],
              )

          
             ],
          ),
        ),
        


       
      ],
    ): Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error, color: AppTheme.dangerColor,),
            Text("No Store Selected", style: TextStyle(color: AppTheme.dangerColor),),
          ],
        ),
      ),
    );

    });
    
  }
}