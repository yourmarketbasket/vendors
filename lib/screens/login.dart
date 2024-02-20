import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:nisoko_vendors/screens/landing.dart';
import 'package:nisoko_vendors/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _username;
  late TextEditingController _password;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _password = TextEditingController();
    doWhenWindowReady(() {
      var initialSize = Size(320, 500);
      appWindow.size = initialSize;
      appWindow.maxSize = initialSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String feedback = "";

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.lock_open_outlined, color: Colors.white),
            Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppTheme.backgroundColor,
        actions: [
          MinimizeWindowButton(colors: AppTheme.windowButtonColors),
          MaximizeWindowButton(colors: AppTheme.windowButtonColors),
          CloseWindowButton(colors: AppTheme.windowButtonColors),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(feedback),
              TextField(
                
                style: TextStyle(color: Colors.white),
                controller: _username,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hoverColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.dialpad_rounded),
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                            
                ),
                
              ),
              SizedBox(height: 20),
              TextField(
                controller: _password,
                obscureText: _obscureText,
                style: TextStyle(color: Colors.white),
                obscuringCharacter: "x",
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  prefixIcon: Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Stack(                
                children: [
                  Container(
                    height: 50, // Adjust height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.mainColor.withOpacity(0.8), // Adjust opacity here
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    width: 280,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: AppTheme.mainColor,
                            elevation: 0, // Remove button elevation
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_outlined, color: Colors.white),
                              Text("Login", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 20,// Ensure the Container has constraints
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 1,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0), // Adjust padding as needed
                      child: Text("OR", style: TextStyle(color: AppTheme.mainColor, fontSize: 10)),
                    ),
                    Container(
                      width: 100,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Stack(                
                children: [
                  Container(
                    height: 50,
                    width: 150, // Adjust height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.dangerColor.withOpacity(0.8), // Adjust opacity here
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: AppTheme.dangerColor,
                            elevation: 0, // Remove button elevation
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add_alt, color: Colors.white),
                              Text("Register", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Text("Forgot Password?", style: TextStyle(fontSize: 10, color: Colors.white),),

              SizedBox(height: 20,),
              Text("\u00A9"+DateTime.now().year.toString()+" All Rights Reserved", style: TextStyle(fontSize: 10, color: Colors.white),)






            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }
}
