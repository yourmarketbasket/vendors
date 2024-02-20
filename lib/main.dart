import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nisoko_vendors/screens/landing.dart';
import 'package:nisoko_vendors/screens/login.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'dart:ui' as ui;


void main() {
  runApp(const EntryPage());
}

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(    
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,    
      home: MoveWindow(
        child: LoginScreen(),
      ),
    );
  }
}

