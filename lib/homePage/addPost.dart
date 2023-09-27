import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatoes/Components/label_textfield.dart';
import 'package:tomatoes/Components/textfield_login.dart';
import 'package:tomatoes/Components/material_button.dart';

class addPost extends StatelessWidget {
  final textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  addPost({
    super.key,
  });

  /// Things to do: create POSt API to post new data from user post
  /// create GET APT that get information given the ID number
  /// In firebase, user's favorite store recipe id to favorite collection, then use id to retrieve the entire information from google sheet.

  ///
  ///User post field
  ///Title
  ///

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
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      // decoration: BoxDecoration(
                      //   shape: BoxShape.circle,
                      //   color: Color.fromRGBO(255, 226, 220, 0.68),
                      // ),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Text('Add New Recipe'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    label_texfield(
                      controller: textController,
                      labelText: 'Write your recipe...',
                    ),
                    material_button(
                      onTap: () => postMessage(context),
                      text: 'Post',
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
