import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nisoko_vendors/controllers/landing-controller.dart';
import 'package:nisoko_vendors/controllers/stores-controller.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'package:nisoko_vendors/utils/constants.dart';
import 'package:nisoko_vendors/utils/functions.dart';
import 'package:nisoko_vendors/utils/widgets.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  late IO.Socket socket;
  List<String> _selectedItems = [];
  List<String> _selectedOrderItems = [];

  bool _selectAll = false;
  bool _selectAllOrders = false;

  final ScrollController _scrollController = ScrollController();
  LandingController landingController = Get.put(LandingController());
  StoresController storesController = Get.put(StoresController());
  TextEditingController _searchController = TextEditingController();
  FocusNode allProductsFocusNode = FocusNode();
  FocusNode ordersFocusNode = FocusNode();

  


  @override
  void initState() {
    super.initState();
    connect();    
  }
  
  void connect(){
    socket = IO.io(Constants.serverLink, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('addproductevent', (productId) {
      // Update the storeproducts list
      storesController.getSelectedStore();
    });
  
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
      final storeStats = storesController.storeproducts.value != null &&
                            storesController.storeproducts.value.isNotEmpty &&
                            storesController.storeproducts.value is String
                            ? calculateProductStatistics(storeProducts)
                            : null;
      final storeOrders = storesController.storeorders.value != null &&
                            storesController.storeorders.value.isNotEmpty &&
                            storesController.storeorders.value is String
                            ? jsonDecode(storesController.storeorders.value)
                            : null;
                       

      return storesController.selectedStore.value.isNotEmpty ? Column(
      children: [

         Padding(
          padding: const EdgeInsets.only(left:20.0, right: 20, top: 20),
          child: Column(
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                          children: [
                            Column(
                              children: [
                                Row(
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
                            ButtonContainer(icon: Icons.refresh_rounded, onPressed: (){
                              storesController.getSelectedStore();
                            }),                           
                          
                          ],
                        )
                            
                    ],
                  ),
                  SizedBox(width: 30,),
                  Container(
                    width: 0.5*dw,
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
              storeProducts!=null ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Column(
                    children: [

                      Row(
                        children: [
                          Icon(Icons.apps, color: Colors.white),
                          Text("All Products (${storeProducts.length.toString()})", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        width: 0.3*dw,
                        child: ListTile(
                          tileColor: AppTheme.accentBgColor,
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
                        height: 0.25 * dh,
                        width: 0.3 * dw,
                        decoration: BoxDecoration(
                          color: AppTheme.accentBgColor
                        ),
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: storeProducts.length,
                            itemBuilder: (BuildContext context, int index) {
                              final productName = storeProducts[index]['name']?.toString() ?? '';
                              final isSelected = _selectedItems.contains(productName);
                          
                              return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(productName, style: TextStyle(color: Colors.white)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("Remaining: ${formatNumber(storeProducts[index]['quantity'])}", style: TextStyle(fontSize: 8, color: Colors.white)),
                                        Text("Posted ${calculateTimeDifference(storeProducts[index]['createdAt'])}", style: TextStyle(fontSize: 8, color: AppTheme.blueAccent))
                                      ],
                                    )
                                  ],
                                ),
                                leading: IconButton(
                                  icon: isSelected ? Icon(Icons.check_circle, color: Colors.white,) : Icon(Icons.circle_outlined, color: Colors.white,),
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
                                              editProductDetailsDialog(context, storeProducts[index], dh, dw);
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
                                    : GestureDetector(
                                        onTap: () {
                                          storesController.product.value = storeProducts[index];
                                          showProductDetailsDialog(context, storesController.product, dh, dw);
                                        },
                                        child: Container(
                                          width: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.white), // Set the border color
                                          ),
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.visibility, color: Colors.white,),
                                            ],
                                          ),
                                        ),
                                      )
                              );
                            },
                          ),
                        ),
                      ),
                      Divider(),
                      storeOrders!=null ? showGroupedStoreOrders(context: context, groupedOrders: storeOrders, dw: dw, dh: dh ): Center(child: Text("No Orders Found"),)
                     
                    ],

                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.line_axis, color: Colors.white,),
                          Text("Store Stats", style: TextStyle(color: Colors.white)),
                        ],
                      ),    
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          createShadowedContainer(
                            height: 0.2*dh, 
                            width: 0.1*dw, 
                            color: AppTheme.mainColor, 
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.list_alt, color: Colors.white,),
                                    Text('Orders',style: TextStyle(color: Colors.white, ), ),
                                    Text(
                                      formatNumber(storeOrders!=null ? storeOrders.length: 0),
                                      style: TextStyle(color: Colors.white, fontSize: 40),
                                    )
                                  ],
                                )
                              ],
                            )
                          ),      
                          SizedBox(width: 30,),                    
                          createShadowedContainer(
                            height: 0.2*dh, 
                            width: 0.1*dw, 
                            color: Colors.pinkAccent, 
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.wallet, color: Colors.white,),
                                    Text('Investment',style: TextStyle(color: Colors.white, )),
                                    Text(
                                      formatNumber(storeStats!['totalInvestment']),
                                      style: TextStyle(color: Colors.white, fontSize: 40),
                                    )
                                  ],
                                )
                              ],
                            )
                          ),
                          SizedBox(width: 30,),
                          createShadowedContainer(
                            height: 0.2*dh, 
                            width: 0.1*dw, 
                            color: Colors.blue, 
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.wallet_membership_outlined, color: Colors.white,),
                                    Text('Profit', style: TextStyle(color: Colors.white)),
                                    Text(
                                      formatNumber(storeStats!['totalProfit']),
                                      style: TextStyle(color: Colors.white, fontSize: 40),
                                    )
                                  ],
                                )
                              ],
                            )
                          ),
                          SizedBox(width: 30,),
                          createShadowedContainer(
                            height: 0.2*dh, 
                            width: 0.1*dw,  
                            color: AppTheme.blueAccent, 
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.percent_outlined, color: Colors.white,),
                                    Text('ROI%', style: TextStyle(color: Colors.white),),
                                    Text(
                                      storeStats!['profitPercentage'].toString(),
                                      style: TextStyle(color: Colors.white, fontSize: 40),
                                    )
                                  ],
                                )
                              ],
                            )
                          ),

                        ],
                      ),
                      SizedBox(height: 20,),
                      Text(
                        'Most Profitable Products',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              createShadowedContainer(
                                height: 0.15*dh, 
                                width: 0.13*dw,  
                                color: Colors.teal, 
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                   Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.computer, color: Colors.white,),
                                        Text('SALES', style: TextStyle(color: Colors.white),),
                                        Text(
                                          storeOrders != null
                                            ? NumberFormat("#,###").format(storeOrders.isNotEmpty
                                                ? calculateTotalSalesAndInvestment(storeOrders)['totalSales']?.toDouble()
                                                : 0) + "/-"
                                            : "0",
                                          style: TextStyle(color: Colors.white, fontSize: 30),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ),
                              SizedBox(height: 20,),
                              createShadowedContainer(
                                height: 0.15*dh, 
                                width: 0.13*dw,  
                                color: Colors.deepPurple, 
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                   Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.wallet_sharp, color: Colors.white,),
                                        Text('PROFIT', style: TextStyle(color: Colors.white),),
                                        Text(
                                          storeOrders != null
                                            ? NumberFormat("#,###").format(storeOrders.isNotEmpty
                                                ? (calculateTotalSalesAndInvestment(storeOrders)['profit'])?.toDouble()
                                                : 0) + "/-"
                                            : "0",
                                          style: TextStyle(color: Colors.white, fontSize: 30),
                                        ),

                                      ],
                                    ),
                                  ],
                                )
                              ),
                            ],
                          ),
                          SizedBox(width: 30,),
                          Container(
                            height: 0.35*dh, 
                            width: 0.3*dw, 
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppTheme.accentBgColor
                            ),
                            child: buildBestPerformingProductsChart(storeStats!['bestPerformingProducts'],dh,dw)),
                          SizedBox(width: 20,),
                        ]
                      ),
                      

                    ],
                  ),
                                   
                  
                ],
              ): Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: AppTheme.dangerColor,),
                      Text("No products in store [${store['storename'].toUpperCase()}]", style: TextStyle(color: AppTheme.dangerColor),),
                    ],
                  ),
              

          
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