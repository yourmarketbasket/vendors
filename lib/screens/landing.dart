import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:nisoko_vendors/controllers/landing-controller.dart';
import 'package:nisoko_vendors/controllers/stores-controller.dart';
import 'package:nisoko_vendors/screens/account.dart';
import 'package:nisoko_vendors/screens/notifications.dart';
import 'package:nisoko_vendors/screens/stores.dart';
import 'package:nisoko_vendors/screens/support.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'package:nisoko_vendors/utils/sidebar.dart';
import 'package:nisoko_vendors/utils/widgets.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key); // Add 'required' modifier

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LandingController landingController = Get.put(LandingController());
  StoresController storesController = Get.put(StoresController());

  @override
  void initState() {
    super.initState();
    doWhenWindowReady(() {
      appWindow.size = Size(1250, 650);
      
    });
    landingController.getUserDetails();
    storesController.getStores();

    openDrawer();
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
   final h = MediaQuery.of(context).size.height;
   final w = MediaQuery.of(context).size.width;

   String _currentPage = landingController.currentPage.value; 

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // the draggable title bar
          WindowTitleBarBox(
            child: Container(
              padding: EdgeInsets.all(5),
              width: w,
              height: 100,
              color: Color.fromARGB(255, 2, 2, 54),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: (){
                          _scaffoldKey.currentState?.openDrawer();
            
                    }, 
                    child: Icon(Icons.menu, color: Colors.white,)
                  ),
                  Expanded(child: MoveWindow(child: Text("Nisoko Vendors v.1.1.0", style: TextStyle(color: Colors.white),))),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          appWindow.minimize();
                        }, 
                        icon: Icon(Icons.circle, color: Colors.amber, size: 15,)
                      ),
                      
                      IconButton(
                        onPressed: (){
                          appWindow.maximizeOrRestore();
                        }, 
                        icon: Icon(Icons.circle, color: AppTheme.mainColor, size: 15)
                      ),
                      IconButton(
                        onPressed: (){
                          appWindow.close();
                        }, 
                        icon: Icon(Icons.circle, color: Colors.red, size: 15)
                      ),
                    ],
                  )
            
                                    
                ],
              ),
            ),
          ),
          Obx(() {
            if(landingController.currentPage.value == "AccountScreen"){
                return AccountScreen();
            } else if(landingController.currentPage.value=="StoresScreen"){
              return StoresScreen();
            } else if(landingController.currentPage.value=="NotificationsScreen"){
              return NotificationsScreen();
            } else if(landingController.currentPage.value=="SupportScreen"){
              return SupportScreen();
            }else{
              return StoresScreen();
            }
          }),
        ]
      ),
      drawer: Sidebar(),
      floatingActionButton: SpeedDial(
        buttonSize: Size(50, 50),
        backgroundColor: AppTheme.mainColor,
        overlayColor: Colors.transparent,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.menu_rounded),
            label: "Sidebar",
            onTap: openDrawer
          ),
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.add_business_outlined),
            label: "Add Store",
          ),
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.terminal),
            label: "POS",
          ),
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.toggle_on_outlined),
            label: "Toggle Store",
            onTap: (){
              openDialog(context);
            }
          ),
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.notes_rounded),
            label: "Logs",
          ),
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.settings),
            label: "Settings",
          ),
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.line_axis),
            label: "Analysis",
          ),


        ],
      ),
    );
  }

  
}
