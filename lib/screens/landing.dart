import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisoko_vendors/controllers/landing-controller.dart';
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

  @override
  void initState() {
    super.initState();
    doWhenWindowReady(() {
      var initialSize = Size(1200, 650);
      appWindow.size = initialSize;
      appWindow.minSize = initialSize;
    });
    landingController.getUserDetails();
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

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // the draggable title bar
          WindowTitleBarBox(
            child: MoveWindow(
              child: Container(
                padding: EdgeInsets.all(5),
                width: w,
                height: 100,
                color: Color.fromARGB(255, 0, 0, 19),
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
                    Text("Nisoko Vendors v.1.1.0", style: TextStyle(color: Colors.white),),
                    Row(
                      children: [
                        MinimizeWindowButton(),
                        MaximizeWindowButton(),
                        CloseWindowButton()
                      ],
                    )

                                      
                  ],
                ),
              ),
            ),
          ),
          
        ]
      ),
      drawer: Sidebar(),
      floatingActionButton: FloatingActionButton(
        onPressed: openDrawer,
        child: Icon(Icons.menu),
      ),
    );
  }
}
