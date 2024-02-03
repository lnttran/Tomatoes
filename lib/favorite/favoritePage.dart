import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/method/APIs.dart';
import 'package:tomatoes/recipe/recipeCard.dart';

class favoritePage extends StatefulWidget {
  const favoritePage({super.key});

  @override
  State<favoritePage> createState() => _favoritePageState();
}

class _favoritePageState extends State<favoritePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'My Favorite',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    List<dynamic> favoriteRecipeList =
                        userData['FavoriteRecipe'];
                    return ListView.builder(
                        itemCount: favoriteRecipeList.length,
                        itemBuilder: (context, index) {
                          final currentRecipeID = favoriteRecipeList[index];
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Recipes')
                                  .doc(currentRecipeID)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final recipeData = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: recipeCard(
                                      onRecipeCardClicked: () =>
                                          APIs.onRecipeCardClicked(
                                              currentRecipeID),
                                      recentlyView: false,
                                      recipe: Recipe.fromJson(recipeData),
                                      isFave: true,
                                      recipeUID: currentRecipeID,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              });
                        });
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
              ),
            )
            // Expanded(
            //   child: FutureBuilder(
            //     future: httpService.getRecipes(0, 10),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<Recipe>> snapshot) {
            //       if (snapshot.hasData) {
            //         List<Recipe> recipes = snapshot.data!;
            //         return ListView(
            //           children: recipes
            //               .map(
            //                 (Recipe recipe) => Padding(
            //                   padding: const EdgeInsets.only(bottom: 15.0),
            //                   child: recipeCard(
            //                     onRecipeCardClicked: () {},
            //                     recentlyView: false,
            //                     recipe: recipe,
            //                     isFave: true,
            //                   ),
            //                 ),
            //               )
            //               .toList(),
            //         );
            //       } else {
            //         return const Center(child: CircularProgressIndicator());
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
