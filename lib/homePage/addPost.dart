import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:tomatoes/Components/label_textfield.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/Components/material_button.dart';
import 'package:tomatoes/homePage/addImageSection.dart';
import 'package:tomatoes/method/APIs.dart';

class addPost extends StatefulWidget {
  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tolCalController = TextEditingController();
  final servingsController = TextEditingController();
  final timeSpendController = TextEditingController();
  final List<TextEditingController> ingredientsControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> instructionsControllers = [
    TextEditingController()
  ];

  final currentUser = FirebaseAuth.instance.currentUser!;
  final GlobalKey<FormState> titleFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> descriptionFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> totCalFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> servingFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> timeSpendFormKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> ingredientsFormKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> instructionsFormKey = GlobalKey<FormState>();

  bool validateAllFormKeys() {
    bool isValidated = false;
    bool titleValidated = titleFormKey.currentState?.validate() ?? false;
    bool descriptionValidated =
        descriptionFormKey.currentState?.validate() ?? false;
    bool totcalValidated = totCalFormKey.currentState?.validate() ?? false;
    bool servingValidated = servingFormKey.currentState?.validate() ?? false;
    // bool ingredientsValidated =
    //     ingredientsFormKey.currentState?.validate() ?? false;
    // bool instructionsValidated =
    //     instructionsFormKey.currentState?.validate() ?? false;

    if (titleValidated &&
            descriptionValidated &&
            totcalValidated &&
            servingValidated
        // ingredientsValidated &&
        // instructionsValidated
        ) {
      isValidated = true;
    }
    return isValidated;
  }

  void removeEmptyControllers() {
    setState(() {
      instructionsControllers
          .removeWhere((controller) => controller.text.trim().isEmpty);
      ingredientsControllers
          .removeWhere((controller) => controller.text.trim().isEmpty);
    });
  }

  /// Things to do: create POSt API to post new data from user post
  /// create GET APT that get information given the ID number
  /// In firebase, user's favorite store recipe id to favorite collection, then use id to retrieve the entire information from google sheet.

  ///
  ///User post field
  ///Title
  ///

  // void postMessage(context) {
  //   //Store in firebase

  //   final userPostClass newPost = userPostClass(
  //       postContent: textController.text,
  //       userEmail: currentUser.email!,
  //       likes: [],
  //       timeCreated: DateTime.now().millisecondsSinceEpoch.toString(),
  //       ingredients: [],
  //       totalCal: 0,
  //       timeSpent: 0);

  //   if (textController.text.isNotEmpty) {
  //     FirebaseFirestore.instance.collection('User Posts').add({
  //     });
  //   }

  //   // setState(() {
  //   //   textController.clear();
  //   // });
  //   Navigator.of(context).pop();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            // FocusScope.of(context).unfocus();
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: const Color(0xFFFFE2DC),
            ),
            child: SingleChildScrollView(
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
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Text(
                                'Name of recipe',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                        label_texfield(
                          controller: titleController,
                          labelText: 'Salmon sandwiches',
                          maxlines: 1,
                          maxlength: 50,
                          formkey: titleFormKey,
                          isNumber: false,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Text(
                                'Description',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                        label_texfield(
                          controller: descriptionController,
                          labelText: 'Description',
                          maxlines: 3,
                          maxlength: 300,
                          formkey: descriptionFormKey,
                          isNumber: false,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Text(
                                'Total calories',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: label_texfield(
                                controller: tolCalController,
                                labelText: 'Total calories',
                                maxlines: 1,
                                maxlength: 10,
                                formkey: totCalFormKey,
                                isNumber: true,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 30.0, left: 20),
                              child: Text(
                                'calories',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Text(
                                'Time Spent',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: label_texfield(
                                controller: timeSpendController,
                                labelText: 'Time spend',
                                maxlines: 1,
                                maxlength: 10,
                                isNumber: true,
                                formkey: timeSpendFormKey,
                              ),
                            ),
                            const DropdownTimeUnit(),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Text(
                                'Number of serving',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                        label_texfield(
                          controller: servingsController,
                          labelText: 'Number of servings',
                          maxlines: 1,
                          maxlength: 50,
                          formkey: servingFormKey,
                          isNumber: true,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Text(
                                'Ingredients',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: ingredientsControllers.map((controller) {
                            final optionalFormKey = GlobalKey<FormState>();
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: label_texfield(
                                      controller: controller,
                                      labelText: 'Ingredient',
                                      maxlines: 1,
                                      maxlength: 20,
                                      formkey: optionalFormKey,
                                      isNumber: false,
                                    ),
                                  ),
                                  if (ingredientsControllers.length > 1)
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          ingredientsControllers
                                              .remove(controller);
                                        });
                                      },
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              ingredientsControllers
                                  .add(TextEditingController());
                            });
                          },
                          child: Text('Add More',
                              style: Theme.of(context).textTheme.headlineSmall),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Text(
                                'Instructions',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: instructionsControllers
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final controller = entry.value;
                            final optionalFormKey = GlobalKey<FormState>();
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: label_texfield(
                                      controller: controller,
                                      labelText: 'Step ${index + 1}',
                                      maxlines: 3,
                                      maxlength: 130,
                                      formkey: optionalFormKey,
                                      isNumber: false,
                                    ),
                                  ),
                                  if (instructionsControllers.length > 1)
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          instructionsControllers
                                              .remove(controller);
                                        });
                                      },
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              instructionsControllers
                                  .add(TextEditingController());
                            });
                          },
                          child: Text(
                            'Add More',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        addImageSection(),
                        const SizedBox(
                          height: 40,
                        ),
                        material_button(
                          onTap: () async {
                            addImageSection imageSection =
                                const addImageSection();
                            String? postImage = imageSection.getPostImage();
                            String? imageURL;
                            if (postImage != null) {
                              imageURL =
                                  await APIs.uploadPostPicture(File(postImage));
                            }
                            if (validateAllFormKeys()) {
                              removeEmptyControllers();
                              List<String> ingredients = ingredientsControllers
                                  .map((controller) => controller.text)
                                  .toList();
                              List<String> instructions =
                                  instructionsControllers
                                      .map((controller) => controller.text)
                                      .toList();
                              Recipe userRecipe = Recipe(
                                id: DateTime.now().millisecondsSinceEpoch,
                                name: titleController.text,
                                description: descriptionController.text,
                                ingredients: ingredients,
                                steps: instructions,
                                thumbnail: imageURL!,
                                totalCal: double.parse(tolCalController.text),
                                timeSpend: int.parse(timeSpendController.text),
                                numOfServings:
                                    int.parse(servingsController.text),
                              );

                              await APIs.uploadUserPost(userRecipe);

                              setState(() {
                                titleController.clear();
                                descriptionController.clear();
                                tolCalController.clear();
                                servingsController.clear();
                                timeSpendController.clear();
                                ingredientsControllers.clear();
                                instructionsControllers.clear();
                              });
                              Navigator.of(context).pop();
                            } else {
                              print(
                                  "Validation failed. Please check your form inputs.");
                            }
                          },
                          text: 'Post',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

const List<String> timeUnit = ['mins', 'hours'];

class DropdownTimeUnit extends StatefulWidget {
  const DropdownTimeUnit({super.key});

  @override
  State<DropdownTimeUnit> createState() => _DropdownTimeUnitState();
}

class _DropdownTimeUnitState extends State<DropdownTimeUnit> {
  String dropdownValue = timeUnit.first;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: DropdownButton<String>(
        value: dropdownValue,
        isExpanded: true,
        borderRadius: BorderRadius.circular(15),
        padding: const EdgeInsets.only(left: 15, right: 5),
        dropdownColor: const Color.fromARGB(255, 255, 242, 242),
        style: Theme.of(context).textTheme.headlineSmall,
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        underline: const SizedBox(),
        items: timeUnit.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }
}
