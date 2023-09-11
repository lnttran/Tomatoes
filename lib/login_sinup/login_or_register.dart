import 'package:flutter/material.dart';
import 'package:tomatoes/login_sinup/login.dart';
import 'package:tomatoes/login_sinup/signup.dart';

class logInorRegister extends StatefulWidget {
  const logInorRegister({super.key});

  @override
  State<logInorRegister> createState() => _logInorRegisterState();
}

class _logInorRegisterState extends State<logInorRegister> {
  bool showLoginPage = true;

  //toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return login(
        onTap: togglePages,
      );
    } else {
      return signup(onTap: togglePages);
    }
  }
}
