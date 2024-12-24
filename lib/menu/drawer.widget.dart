import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/global.params.dart';

class MyDrawer extends StatelessWidget {
  final User? user;

  const MyDrawer({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
            ),
            child: Center(
              child: CircleAvatar(
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : AssetImage("assets/default_avatar.jpg") as ImageProvider,
                radius: 60,

              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: GlobalParams.menus.length,
              itemBuilder: (context, index) {
                final menu = GlobalParams.menus[index];
                return ListTile(
                  leading: menu["icon"],
                  title: Text(menu["title"]),
                  onTap: () {
                    if (user == null) {
                      _showSignInAlert(context);
                    } else {
                      if (menu["title"] == "Logout") {
                        _showLogoutConfirmation(context);
                      } else {
                        Navigator.pushNamed(context, menu["route"]);
                      }
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  if (user != null) {
                    _showLogoutConfirmation(context);
                  } else {
                    _showSignInAlert(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show alert dialog to prompt the user to sign in
  void _showSignInAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign In Required',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          content: Text(
            'Please sign in to access this feature.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/signIn');
              },
            ),
          ],
        );
      },
    );
  }

  /// Show confirmation dialog before logging out
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Logout',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _handleLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// Handle logout logic
  Future<void> _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }
}
