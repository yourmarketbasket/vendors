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
    landingController.getUserDetails();
    storesController.getStores();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello ${landingController.userdetails['data']['fname']}, Welcome to Nisoko', style: TextStyle(color: Colors.white, fontSize: 12),),
          ],
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.only(left:20.0, right: 20),
          child: Row( 
              mainAxisAlignment: MainAxisAlignment.end,         
              children: [
                ButtonContainer(icon: Icons.terminal_sharp, onPressed: (){}),
                ButtonContainer(icon: Icons.line_axis_rounded, onPressed: (){}),
                ButtonContainer(icon: Icons.add_business_sharp, onPressed: (){}),
                ButtonContainer(icon: Icons.settings, onPressed: (){}),
                ButtonContainer(icon: Icons.toggle_off_outlined, onPressed: (){}),
                ButtonContainer(icon: Icons.refresh_rounded, onPressed: (){ storesController.getStores();}),
              ],
            ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:20.0, right: 20),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.business_center,color: Colors.white),
                      Text("Registered Stores", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  Container(
                    height: 400,
                    width: 350,
                    child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      controller: _scrollController,
                      itemCount: storesController.Stores.value['data'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CheckboxListTile(
                            activeColor: MaterialStateColor.resolveWith((states) => AppTheme.mainColor),
                            tileColor: Color.fromARGB(255, 6, 3, 56),
                            controlAffinity: ListTileControlAffinity.leading,
                            subtitle:Text(storesController.Stores.value['data'][index]['storetype'].toUpperCase(), style: TextStyle(color: const Color.fromARGB(255, 116, 115, 115), fontSize: 10),), 
                            title: Text(storesController.Stores.value['data'][index]['storename'].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 12),),
                            value: _selectedItems.contains(storesController.Stores.value['data'][index]['storename']),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value != null) {
                                  if (value) {
                                    _selectedItems.add(storesController.Stores.value['data'][index]['storename']);
                                  } else {
                                    _selectedItems.remove(storesController.Stores.value['data'][index]['storename']);
                                  }
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),


       
      ],
    );
  }
}