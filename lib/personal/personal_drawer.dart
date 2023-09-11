import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFE9A494),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
          child: ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Log Out'),
          ),
        )
      ]),
    );
  }
}
