import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nisoko_vendors/utils/colors.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(
                    'https://via.placeholder.com/150',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          _buildMenuItem('My Account', icon: Icons.person),
          _buildMenuItem('Stores', icon: Icons.store_mall_directory),
          _buildMenuItem('Notifications', icon: Icons.notifications_active),
          _buildMenuItem('Applications', icon: Icons.list),
          Divider(),
          _buildMenuItem('Logout', icon: Icons.logout),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, {IconData? icon}) {
    return ListTile(
      title: Row(
        children: [
          if (icon != null) Icon(icon, color: AppTheme.backgroundColor),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      onTap: () {
        // Handle menu item tap
      },
    );
  }
}