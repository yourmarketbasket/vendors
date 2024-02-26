import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Padding(
          padding: const EdgeInsets.only(left:20.0, right: 20, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() {
                          final store = storesController.selectedStore.value.isNotEmpty ? jsonDecode(storesController.selectedStore.value) : null;
                          return Row(
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
                              ButtonContainer(icon: Icons.refresh_rounded, onPressed: (){ storesController.getStores();}),
                            
                            
                            ],
                          );
                        }),

                      ],
                    ),
                  ),
                 ],
              )
            ],
          ),
        ),


       
      ],
    );
  }
}