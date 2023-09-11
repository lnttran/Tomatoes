import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatoes/Components/textfield_login.dart';
import 'package:tomatoes/Components/login_button.dart';

class addPost extends StatelessWidget {
  final textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  addPost({
    super.key,
  });

  void postMessage(context) {
    //Store in firebase
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('User Posts').add({
        'Email': currentUser.email!,
        'Recipe': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    // setState(() {
    //   textController.clear();
    // });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Color(0xFFFFE2DC),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(255, 226, 220, 0.68),
                  ),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: textfield_login(
                  controller: textController,
                  hintText: 'Write your recipe...',
                  obscureText: false,
                ),
              ),
              login_button(
                onTap: () => postMessage(context),
                text: 'Post',
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
