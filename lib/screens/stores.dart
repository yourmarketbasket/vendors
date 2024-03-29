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
  bool _selectAll = false;
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 0.6*dw,
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
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  storeProducts!=null ? Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.apps, color: AppTheme.mainColor),
                          Text("All Products", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Container(
                        width: 0.25*dw,
                        child: ListTile(
                          title: Text(_selectedItems.isEmpty? "Select all" : "Unselect All", style: TextStyle(color: Colors.white)),
                          leading: IconButton(
                            icon: _selectedItems.isEmpty
                                ? Icon(Icons.circle_outlined, color: Colors.white,) // Show outline circle if none are selected
                                : _selectedItems.length == storeProducts.length
                                    ? Icon(Icons.check_circle_outline, color: Colors.white,) // Show checked outline circle if all are selected
                                    : Icon(Icons.circle, color: Colors.white,), // Show circle if some are selected
                            onPressed: () {
                              setState(() {
                                bool isSelected = _selectedItems.isNotEmpty;
                                if (isSelected) {
                                  _selectedItems.clear(); // Deselect all products
                                } else {
                                  _selectedItems.addAll(storeProducts
                                      .map<String?>((product) => product['name']?.toString())
                                      .where((name) => name != null)
                                      .cast<String>());
                                }
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              bool isSelected = _selectedItems.isNotEmpty;
                              if (isSelected) {
                                _selectedItems.clear(); // Deselect all products
                              } else {
                                _selectedItems.addAll(storeProducts
                                    .map<String?>((product) => product['name']?.toString())
                                    .where((name) => name != null)
                                    .cast<String>());
                              }
                            });
                          },
                          trailing: _selectedItems.isNotEmpty
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete_outline_rounded, color: AppTheme.dangerColor),
                                      onPressed: () {
                                        // Handle delete action
                                      },
                                    ),
                                  ],
                                )
                              : null,
                        ),

                      ),

                      Container(
                        height: 0.6*dh,
                        width: 0.25*dw,
                        child: ListView.builder(
                        itemCount: storeProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final productName = storeProducts[index]['name']?.toString() ?? '';
                          final isSelected = _selectedItems.contains(productName);
                      
                          return ListTile(
                            title: Text(productName, style: TextStyle(color: Colors.white)),
                            leading: IconButton(
                              icon: isSelected ? Icon(Icons.check_circle, color: AppTheme.mainColor,) : Icon(Icons.circle_outlined, color: Colors.white,),
                              onPressed: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedItems.remove(productName);
                                  } else {
                                    _selectedItems.add(productName);
                                  }
                                });
                              },
                            ),
                            onTap: () {                                      
                              setState(() {
                                if (isSelected) {
                                  _selectedItems.remove(productName);
                                } else {
                                  storesController.product.value = storeProducts[index];
                                  showProductDetailsDialog(context, storesController.product, dh, dw);
                                  _selectedItems.add(productName);
                                }
                              });
                            },
                            trailing: isSelected
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit_document, color: Colors.white,),
                                        onPressed: () {
                                          // Handle edit action
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: AppTheme.dangerColor,),
                                        onPressed: () {
                                          // Handle delete action
                                        },
                                      ),
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      storesController.product.value = storeProducts[index];
                                      showProductDetailsDialog(context, storesController.product, dh, dw);

                                    },
                                    child: Text("view"),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ),

                          );
                        },
                      ),
                      ),
                    ],
                  ): Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: AppTheme.dangerColor,),
                      Text("No products in store [${store['storename'].toUpperCase()}]", style: TextStyle(color: AppTheme.dangerColor),),
                    ],
                  ))
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