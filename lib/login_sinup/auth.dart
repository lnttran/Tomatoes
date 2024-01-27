//check if the user is sign in or not
import 'package:tomatoes/Components/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatoes/login_sinup/login_or_register.dart';

class auth extends StatelessWidget {
  const auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //user is login
            if (snapshot.hasData) {
              return const bottom_bar();
            } else {
              return const logInorRegister();
            }
          }),
    );
  }
}
