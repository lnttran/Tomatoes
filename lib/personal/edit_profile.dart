import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomatoes/Components/text_box.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/method/APIs.dart';

class edit_profile extends StatefulWidget {
  edit_profile({
    super.key,
  });

  @override
  State<edit_profile> createState() => _edit_profileState();
}

class _edit_profileState extends State<edit_profile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');
  String? _image;

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print('Image Path : ${image.path}');
        setState(() {
          _image = image.path;
        });
        APIs.updateProfilePicture(File(_image!));
        Navigator.pop(context);
      }
    } catch (e) {
      print('Image picking error: $e');
    }
  }

  Future takeImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        print('Image Path : ${image.path}');
        setState(() {
          _image = image.path;
        });
        APIs.updateProfilePicture(File(_image!));
        Navigator.pop(context);
      }
    } catch (e) {
      print('Image picking error: $e');
    }
  }

  void editField(String field, context) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFBFB0),
        title: Text('Edit $field'),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: const TextStyle(
              fontSize: 12,
            ),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //Cancel button
          TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context)),

          //Save button
          TextButton(
              child: const Text('Save'),
              onPressed: () => Navigator.of(context).pop(newValue)),
        ],
      ),
    );

    //update in the firestore
    if (newValue.trim().length > 1) {
      await userCollection.doc(currentUser.uid).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              // Add your button's functionality here
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.black, // Set the text color
              ),
            ),
          ),
        ],
        actionsIconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userCollection.doc(currentUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(thisSize.height * .3),
                        child: _image != null
                            ? Image.file(
                                File(_image!),
                                width: thisSize.height * .15,
                                height: thisSize.height * .15,
                                fit: BoxFit.cover,
                              )
                            : userData['Image'] != ''
                                ? CachedNetworkImage(
                                    width: thisSize.height * .15,
                                    height: thisSize.height * .15,
                                    imageUrl: userData['Image'],
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: thisSize.height * .15,
                                      height: thisSize.height * .15,
                                      decoration: const BoxDecoration(
                                        //shape: BoxShape.circle,
                                        color: Color(0xFFF83015),
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: thisSize.height * .15,
                                    height: thisSize.height * .15,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF83015),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: thisSize.height * 0.1,
                                    ),
                                  ),
                      ),
                      Positioned(
                        top: thisSize.height * .09,
                        left: thisSize.height * .06,
                        child: MaterialButton(
                          height: thisSize.height * 0.04,
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          shape: const CircleBorder(),
                          color: const Color(0xFFFFBFB0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: thisSize.height * 0.025,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    userData['Email'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  MyTextBox(
                    text: userData['First_name'],
                    sectionName: 'First name',
                    onTap: () => editField('First_name', context),
                  ),
                  MyTextBox(
                    text: userData['Last_name'],
                    sectionName: 'Last name',
                    onTap: () => editField('Last_name', context),
                  ),
                  MyTextBox(
                    text: userData['Username'],
                    sectionName: 'Username',
                    onTap: () => editField('Username', context),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: const Color(0xFFFFE2DC),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: thisSize.height * .03),
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text(
                  'Photos from library',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                onTap: pickImage,
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text(
                  'Take photo',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                onTap: takeImage,
              ),
            ],
          );
        });
  }
}
