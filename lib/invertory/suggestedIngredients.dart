import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/method/APIs.dart';
import 'package:tomatoes/recipe/recipeCard.dart';

class suggestedIngredientPage extends StatefulWidget {
  const suggestedIngredientPage({super.key});

  @override
  State<suggestedIngredientPage> createState() =>
      _suggestedIngredientPageState();
}

class _suggestedIngredientPageState extends State<suggestedIngredientPage> {
  bool isLoading = true;
  int numOfRecipePerPage = 20;
  late DocumentSnapshot? lastDocument;
  List<DocumentSnapshot> listOfRecipes = [];
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');

  getRecipe() async {
    QuerySnapshot querySnapshot = await userCollection
        .doc(currentUser.uid)
        .collection('Available Ingredients')
        .get();

    // List<DocumentSnapshot> ingredientDocSnapshot = querySnapshot.docs;
    List<String> ingredientDoc =
        querySnapshot.docs.map((doc) => doc.id).toList();

    setState(() {
      isLoading = true;
    });

    if (ingredientDoc.isNotEmpty) {
      Query recipesQuery = FirebaseFirestore.instance
          .collection('Recipes')
          .where('ingredients',
              arrayContainsAny: ingredientDoc.map((type) => type))
          .limit(numOfRecipePerPage);

      QuerySnapshot querySnapshot = await recipesQuery.get();

      List<Map<String, dynamic>> recipesWithMatches = [];
      for (QueryDocumentSnapshot recipeSnapshot in querySnapshot.docs) {
        Map<String, dynamic> recipeData =
            recipeSnapshot.data() as Map<String, dynamic>;
        List<dynamic> recipeIngredients =
            List<dynamic>.from(recipeData['ingredients']);

        // Calculate the number of matching ingredients
        int matches = ingredientDoc
            .where((ingredient) => recipeIngredients.contains(ingredient))
            .length;

        // Check if the recipe contains at least one matching ingredient
        if (matches > 0) {
          recipesWithMatches.add({
            'recipeId': recipeSnapshot.id,
            'matches': matches,
          });
        }
      }

      recipesWithMatches.sort((a, b) => a['matches'].compareTo(b['matches']));

      // Get the sorted recipe IDs
      List<dynamic> sortedRecipeIds =
          recipesWithMatches.map((recipe) => recipe['recipeId']).toList();

      // Retrieve the recipes using the sorted IDs
      List<DocumentSnapshot> sortedRecipes = await FirebaseFirestore.instance
          .collection('Recipes')
          .where(FieldPath.documentId, whereIn: sortedRecipeIds)
          .get()
          .then((querySnapshot) => querySnapshot.docs);

      setState(() {
        isLoading = false;
        lastDocument = sortedRecipes.isNotEmpty ? sortedRecipes.last : null;
        listOfRecipes = sortedRecipes;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const SizedBox(
            width: 50,
            height: 45,
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Text(
          'Suggested Recipe',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.start,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15,
            top: 15,
          ),
          child: Column(
            children: [
              // Ro
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listOfRecipes.length,
                  itemBuilder: ((context, index) {
                    final recipeID = listOfRecipes[index].id;
                    final recipe =
                        listOfRecipes[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: recipeCard(
                        onRecipeCardClicked: () =>
                            APIs.onRecipeCardClicked(recipeID),
                        recentlyView: false,
                        recipe: Recipe.fromJson(recipe),
                        isFave: true,
                        recipeUID: recipeID,
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
