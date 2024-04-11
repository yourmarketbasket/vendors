import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisoko_vendors/controllers/login-controller.dart';
import 'package:nisoko_vendors/screens/landing.dart';
import 'package:nisoko_vendors/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _phone;
  late TextEditingController _password;
  bool _obscureText = true;
  String feedback = "";
  bool _formSubmitted = false; // Track whether the form has been submitted or not

  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    feedback = "";
    loginController.error.value = false;

    doWhenWindowReady(() {
      var initialSize = Size(320, 550);
      appWindow.size = initialSize;
    });
    _phone = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: WindowTitleBarBox(
          child: MoveWindow(
            child: Row(
              children: [
                Icon(Icons.lock_open_outlined, color: Colors.white),
                Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        actions: [
          MinimizeWindowButton(colors: AppTheme.windowButtonColors),
          MaximizeWindowButton(colors: AppTheme.windowButtonColors),
          CloseWindowButton(colors: AppTheme.windowButtonColors),
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            height: 550,
            width: 320,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              loginController.error.value && _formSubmitted
                                  ? Icons.error_outline
                                  : Icons.check_circle_outline,
                              color: loginController.error.value
                                  ? AppTheme.dangerColor
                                  : AppTheme.mainColor,
                            ),
                            Text(
                              loginController.feedback.value,
                              style: TextStyle(
                                color: loginController.error.value && _formSubmitted
                                    ? AppTheme.dangerColor
                                    : AppTheme.mainColor,
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 10,),
                    TextFormField(
                      validator: (value) {
                        if (_formSubmitted &&
                            (value == null || value.isEmpty)) {
                          return 'Mobile Number is Required!';
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.white),
                      controller: _phone,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                        errorText: _formSubmitted && _phone.text.isEmpty
                            ? 'Mobile Number is Required!'
                            : null,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: "Phone Number",
                        prefixIcon: Icon(Icons.dialpad_rounded),
                        focusColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (_formSubmitted &&
                            (value == null || value.isEmpty)) {
                          return 'Password is Required!';
                        }
                        return null;
                      },
                      controller: _password,
                      obscureText: _obscureText,
                      style: TextStyle(color: Colors.white,),
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                        errorText: _formSubmitted && _password.text.isEmpty
                            ? 'Password is Required!'
                            : null,
                        focusColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
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
                                color: AppTheme.mainColor.withOpacity(0.8),
                                // Adjust opacity here
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
                              filter: ImageFilter.blur(
                                  sigmaX: 10, sigmaY: 10),
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _formSubmitted = true;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    Map<String, dynamic> data = {
                                      "phone": _phone.text,
                                      "password": _password.text
                                    };
                                    final Map<String, dynamic> response =
                                        await loginController
                                            .loginUser(context, data);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.mainColor,
                                  elevation: 0, // Remove button elevation
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout_outlined,
                                        color: Colors.white),
                                    Text("Login",
                                        style: TextStyle(color: Colors.white)),
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
                      height: 20, // Ensure the Container has constraints
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0), // Adjust padding as needed
                            child: Text("OR",
                                style: TextStyle(
                                    color: AppTheme.mainColor, fontSize: 10)),
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
                                color: AppTheme.dangerColor.withOpacity(0.8),
                                // Adjust opacity here
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
                              filter: ImageFilter.blur(
                                  sigmaX: 10, sigmaY: 10),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.dangerColor,
                                  elevation: 0, // Remove button elevation
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person_add_alt,
                                        color: Colors.white),
                                    Text("Register",
                                        style: TextStyle(
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Forgot Password?",
                        style:
                            TextStyle(fontSize: 10, color: Colors.white)),
                    SizedBox(
                      height: 20,
                    ),
                    Text("\u00A9" +
                        DateTime.now().year.toString() +
                        " All Rights Reserved",
                        style:
                            TextStyle(fontSize: 10, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }
}
