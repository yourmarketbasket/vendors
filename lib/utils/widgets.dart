import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

SizedBox sideBar(){
  return SizedBox(
    width: 200,
    child: Container(
      color: Colors.white,
      child: Column(
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
    ),
  );
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