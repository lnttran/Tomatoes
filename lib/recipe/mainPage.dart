import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/personal/personal.dart';
import 'package:tomatoes/recipe/recipeCard.dart';
import 'package:http/http.dart' as http;
import 'package:tomatoes/service/http_service.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

enum tags {
  Main,
  Breakfast,
  Vegan,
  All,
  Soup,
  Beef,
  Japeneses,
}

class _mainPageState extends State<mainPage> {
  final HttpService httpService = HttpService();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    //set to track the selected data
    Set<tags> selectedTags = Set<tags>(); // To store selected tags
    return SafeArea(
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: userCollection.doc(currentUser.email).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Row(
                      children: [
                        ClipRRect(
                            borderRadius:
                                BorderRadius.circular(thisSize.height * .3),
                            child:
                                //                                 // userData['Image'] != ''
                                //                                 //     ?
                                CachedNetworkImage(
                              width: thisSize.width * .15,
                              height: thisSize.width * .15,
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
                              errorWidget: (context, url, error) => Container(
                                width: thisSize.width * .15,
                                height: thisSize.width * .15,
                                decoration: BoxDecoration(
                                  //shape: BoxShape.circle,
                                  color: Color(0xFFF83015),
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            //                             // : Container(
                            //                             //     width: thisSize.height * .15,
                            //                             //     height: thisSize.height * .15,
                            //                             //     decoration: BoxDecoration(
                            //                             //       color: Color(0xFFF83015),
                            //                             //     ),
                            //                             //     child: Icon(
                            //                             //       Icons.person,
                            //                             //       color: Colors.white,
                            //                             //       size: thisSize.height * 0.1,
                            //                             //     ),
                            //                             //   ),
                            //                             ),
                            ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Hi ' + userData['First_name'] + ',',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              SizedBox(
                height: 25,
              ),
              //Search bar
              Row(
                children: [
                  Text(
                    'Get your recipe!',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              // search box
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: 'Search',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFFFFE2DC),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(
                          0xFFF83015), // Set the color for the focused border line
                      width: 2, // Set the thickness for the focused border line
                    ),
                  ),
                ),
              ),

              /**
               * Tags list 
               */
              SizedBox(
                height: 70,
                child: ListView.builder(
                  itemCount: tags.values.length,
                  scrollDirection: Axis.horizontal, // Scroll horizontally
                  itemBuilder: (context, index) {
                    final tag = tags.values[index];
                    // Define text styles for selected and unselected states
                    TextStyle selectedTextStyle = TextStyle(
                      color: Colors.white, // Text color when selected
                    );

                    TextStyle unselectedTextStyle = TextStyle(
                      color: Colors.black, // Text color when unselected
                    );
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilterChip(
                          label: Text(tag
                              .toString()
                              .split('.')
                              .last), // Display the tag name
                          selected: selectedTags.contains(tag),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedTags.add(tag);
                              } else {
                                selectedTags.remove(tag);
                              }
                            });
                          },
                          backgroundColor: selectedTags.contains(tag)
                              ? Color(
                                  0xFFF83015) // Background color when selected
                              : Color(
                                  0xFFFFE2DC), // Background color when unselected
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Define the border radius
                          ),
                          labelStyle: TextStyle(
                            color: selectedTags.contains(tag)
                                ? Colors.white // Text color when selected
                                : Colors.black, // Text color when unselected
                          ),
                        ));
                  },
                ),
              ),

              /**
               * Recently view section 
               */
              Row(
                children: [
                  Text(
                    'Recently views',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 200.0,
                child: FutureBuilder(
                  future: httpService.getRecipes(0, 10),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Recipe>> snapshot) {
                    if (snapshot.hasData) {
                      List<Recipe> recipes = snapshot.data!;
                      return ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis
                            .horizontal, // Set the scroll direction to horizontal
                        children: recipes
                            .map(
                              (Recipe recipe) => Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: recipeCard(
                                  recentlyView: true,
                                  recipe: recipe,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Main Course',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // ListView.builder(
              //     itemCount: 8,
              //     physics: NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     //scrollDirection:
              //     //    Axis.horizontal, // Scroll horizontally
              //     itemBuilder: (context, index) {
              //       return Padding(
              //         padding: EdgeInsets.only(
              //             bottom: 15.0), // Adjust the right padding as needed
              //         child: recipeCard(
              //           recentlyView: false,
              //         ),
              //       );
              //     }),
              FutureBuilder(
                future: httpService.getRecipes(0, 10),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Recipe>> snapshot) {
                  if (snapshot.hasData) {
                    List<Recipe> recipes = snapshot.data!;
                    return ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: recipes
                          .map(
                            (Recipe recipe) => Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: recipeCard(
                                recentlyView: false,
                                recipe: recipe,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
