import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nisoko_vendors/screens/login.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'package:nisoko_vendors/utils/widgets.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doWhenWindowReady(() {
      var initialSize = Size(1200, 650);
      appWindow.size = initialSize;
      appWindow.minSize = initialSize;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          sideBar(),
          Expanded(
            child: Column(
              children: [
                WindowTitleBarBox(
                  child: Row(
                    children: [
                      Expanded(child: MoveWindow(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Nisoko Vendors", style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      )),
                      Row(
                        children: [
                          MinimizeWindowButton(colors:AppTheme.windowButtonColors,),
                          MaximizeWindowButton(colors: AppTheme.windowButtonColors),
                          CloseWindowButton(colors: AppTheme.windowButtonColors)
                        ],
                      )                      
                    ],
                  ),
                ),
                
              ],
            ),
          )
        ],
      ),
    );
  }
}

