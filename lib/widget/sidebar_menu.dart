import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zonta/auth/login_screen.dart'; // For SharedPreferences

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            accountName: Text(
              'Fitsum',
              style: TextStyle(color: Colors.black),
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/img_user_default.png'),
            ),
          ),
          _buildMenuItem(context, Icons.person_outline, 'Edit Profile'),
          _buildMenuItem(context, Icons.receipt_long, 'Orders'),
          _buildMenuItem(context, Icons.lock_outline, 'Change Password'),
          _buildMenuItem(context, Icons.chat_bubble_outline, 'Live Chat'),
          _buildMenuItem(context, Icons.location_on_outlined, 'Manage Address'),
          _buildMenuItem(context, Icons.person_add_outlined, 'Invite Friend'),
          _buildMenuItem(context, Icons.credit_card, 'Manage Card'),
          _buildMenuItem(context, Icons.help_outline, 'Help & Support'),
          _buildMenuItem(context, Icons.settings, 'Preference'),
          _buildMenuItem(context, Icons.local_offer_outlined, 'My Coupons'),
          _buildMenuItem(
            context,
            Icons.logout_outlined,
            'Logout',
            onTap: () => _showLogoutDialog(context),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'V1.0.0',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap ??
          () {
            // Close the drawer when menu item is tapped
            Navigator.pop(context);
          },
    );
  }

  // Show confirmation dialog for logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async {
                // Remove user data from SharedPreferences
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                await sharedPreferences.remove('user_id');
                await sharedPreferences.remove('access_token');
                await sharedPreferences.remove('user_name');
                await sharedPreferences.remove('user_token');

                // Navigate to the login screen
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const LoginScreen()), // Adjust the LoginScreen route
                );
              },
            ),
          ],
        );
      },
    );
  }
}
