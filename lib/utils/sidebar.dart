import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nisoko_vendors/controllers/landing-controller.dart';
import 'package:nisoko_vendors/controllers/stores-controller.dart';
import 'package:nisoko_vendors/screens/login.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'package:nisoko_vendors/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  LandingController landingController = Get.put(LandingController());
  StoresController storesController = Get.put(StoresController());

  @override
  void initState() {
    super.initState();
    landingController.getUserDetails();
    if(storesController.selectedStore.value==null){
      openSelectStoreDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 230,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 300,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(
                      landingController.userdetails['data']['avatar'],
                    ),
                  ),
                  SizedBox(height: 10),
                  landingController.userdetails['data']['verified'] ? Icon(Icons.verified, color: AppTheme.mainColor,): Icon(Icons.error, color: Colors.red),
                  Text(
                    '${landingController.userdetails['data']['fname']} ${landingController.userdetails['data']['lname']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${landingController.userdetails['data']['phone']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          _buildMenuItem('Stores', icon: Icons.store_mall_directory, onPressed: (){
            landingController.currentPage.value = "StoresScreen";

          }),
          _buildMenuItem('My Account', icon: Icons.person, onPressed: (){
            landingController.currentPage.value = "AccountScreen";
          }),
          _buildMenuItem('Notifications', icon: Icons.notifications_active, onPressed: (){
            landingController.currentPage.value = "NotificationsScreen";
          }),
          _buildMenuItem('Support', icon: Icons.support_agent_rounded, onPressed: (){
            landingController.currentPage.value = "SupportScreen";
          }),
          Divider(),
          _buildMenuItem('Logout', icon: Icons.logout, onPressed: _logout),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("\u00A9"+DateTime.now().year.toString()+"Nisoko Technologies.", style: TextStyle(fontSize: 10, color: AppTheme.backgroundColor),),
            ],
          )

        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, {IconData? icon, Function()? onPressed,} ) {
    return ListTile(
      title: Row(
        children: [
          if (icon != null) Icon(icon, color: AppTheme.backgroundColor),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
        // Handle menu item tap
      },
    );
  }

  void _logout() async {
    // Delete user ID from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userid');

    await prefs.remove("selectedStore");

    storesController.selectedStore.value = "";

    // Navigate to the login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

}