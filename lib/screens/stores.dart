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
                  Container(
                    height: 200,
                    width: 300,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: storesController.Stores.value['data'].length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
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