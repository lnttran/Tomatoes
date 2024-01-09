import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFE2DC),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
          child: const ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Log Out'),
          ),
        )
      ]),
    );
  }
}
