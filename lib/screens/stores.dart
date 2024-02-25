import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nisoko_vendors/controllers/landing-controller.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'package:nisoko_vendors/utils/widgets.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  LandingController landingController = Get.put(LandingController());

  @override
  void initState() {
    super.initState();
    landingController.getUserDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hello ${landingController.userdetails['data']['fname']}, Welcome to Nisoko', style: TextStyle(color: Colors.white, fontSize: 12),),
            ],
          ),
        ),
        Row(
          
          children: [

          ],
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              createShadowedContainer(
                height: 200, 
                width: 200, 
                color: AppTheme.mainColor, 
                child: Text("here", style: TextStyle(color: Colors.white, fontSize: 12),)
              )
              
            ],
          ),
        ),
      ],
    );
  }
}