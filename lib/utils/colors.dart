import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class AppTheme{
   static Color mainColor = const Color.fromARGB(255, 9, 238, 104);
   static Color backgroundColor = Color.fromARGB(255, 8, 3, 77);
   static Color dangerColor = Color.fromARGB(255, 199, 7, 183);

   static WindowButtonColors windowButtonColors = WindowButtonColors(
    iconNormal: Colors.white,
    mouseOver: Color.fromARGB(255, 14, 8, 90),
    mouseDown: Colors.amber,
    iconMouseOver: Colors.white,

   );
}

