import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/bottom_bar.dart';
import 'package:tomatoes/Components/textfield_login.dart';
import 'package:tomatoes/Components/login_button.dart';
import 'package:tomatoes/method/convertTime.dart';
import 'package:tomatoes/Components/userClass.dart';

//import '../../service/auth_sersice.dart';

class signup extends StatefulWidget {
  final Function()? onTap;
  signup({
    super.key,
    required this.onTap,
  });

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final time = DateTime.now().millisecondsSinceEpoch.toString();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // @override
  // void dispose() {
  //   emailController.dispose();
  //   confirmPasswordController.dispose();
  //   firstNameController.dispose();
  //   lastNameController.dispose();
  //   usernameController.dispose();
  //   passwordController.dispose();
  //   super.dispose();
  // }

  void SignUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          // Make the dialog transparent
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
    //try to sign in
    try {
      UserCredential userCredential;
      //check if the password is confirm
      if (passwordController.text == confirmPasswordController.text) {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          //removes any leaing or trailing withspace characters from the retrieved text
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final user = userClass(
          image: '',
          firstName: firstNameController.text.trim(),
          username: usernameController.text.trim(),
          lastName: lastNameController.text.trim(),
          createAt: time,
          isOnline: false,
          lastActive: time,
          email: emailController.text.trim(),
          pushToken: '',
          id: userCredential.user!.uid,
        );

        final userData = user.toJson();

        FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.email)
            .set(userData);
      } else {
        wrongAlert('Password Does\'t Match');
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      wrongAlert(e.code);
    }
  }

  //display error message on the screen
  void wrongAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF211B25),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Tomatoes",
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Lest\'s creat an account for you!',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    //first name
                    textfield_login(
                      controller: firstNameController,
                      hintText: 'First name',
                      obscureText: false,
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    //Last name
                    textfield_login(
                      controller: lastNameController,
                      hintText: 'Last name',
                      obscureText: false,
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    //user name
                    textfield_login(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    //email address
                    textfield_login(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    //Password
                    textfield_login(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    //confirm password
                    textfield_login(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Passowrd',
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //sign in button
                    login_button(
                      onTap: SignUserUp,
                      text: 'Sign Up',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Color.fromARGB(255, 241, 223, 249),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            'Or continue with',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Color.fromARGB(255, 241, 223, 249),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    alterative(),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Color.fromARGB(255, 241, 223, 249),
                              ),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Log In',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Color.fromARGB(255, 223, 189, 186),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
  //223, 189, 116

  Row alterative() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {}, //=> AuthService().signInwithGoogle(),
          child: Container(
            width: 100,
            child: Image.asset(
              'assets/images/google.png',
              height: 50,
            ),
          ),
        ),
        Container(
          width: 100,
          child: Image.asset(
            'assets/images/apple.png',
            height: 60,
          ),
        )
      ],
    );
  }
}