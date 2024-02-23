import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nisoko_vendors/controllers/landing-controller.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'package:nisoko_vendors/utils/functions.dart';

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