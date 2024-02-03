import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/invertory/addIngredient.dart';
import 'package:tomatoes/invertory/ingreCard.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tomatoes/invertory/ingredientsClass.dart';
import 'package:tomatoes/invertory/suggestedIngredients.dart';
import 'package:tomatoes/method/APIs.dart';

class inventoryPage extends StatefulWidget {
  const inventoryPage({super.key});

  @override
  State<inventoryPage> createState() => _inventoryPageState();
}

class _inventoryPageState extends State<inventoryPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft, // Align text to the left
          child: Row(
            children: [
              Text(
                'My Inventory',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => addIngredient(),
                      // builder: (context) => const TestPage2(),
                    ));
              },
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.uid)
                .collection('Available Ingredients')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final ingredients = snapshot.data!.docs;

                if (ingredients.isEmpty) {
                  return const Center(
                    child: Text("Add your available ingredient!"),
                  );
                }
                Map<String, Map<String, IngredientClass>> ingredientList = {};
                if (ingredients.isNotEmpty) {
                  for (var ingredient in ingredients) {
                    Map<String, dynamic> ingredientData = ingredient.data();

                    String category = ingredientData['category'];
                    String name = ingredientData['name'];

                    // Create a new inner map if the category is not already present
                    if (!ingredientList.containsKey(category)) {
                      ingredientList[category] = {};
                    }

                    // Add the inagredient to the inner map
                    ingredientList[category]![name] =
                        IngredientClass.fromJson(ingredientData);
                  }
                }
                return Column(
                  children: ingredientList.entries.map((entry) {
                    Map<String, IngredientClass> ingredients = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          APIs.capitalizeFirstLetter(entry.key),
                          textAlign: TextAlign.start,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ingredients.length,
                            itemBuilder: (context, index) {
                              String ingredientName =
                                  ingredients.keys.elementAt(index);
                              IngredientClass ingredient =
                                  ingredients[ingredientName]!;

                              return ingredientCard(
                                  onDelete: () =>
                                      APIs.deleteIngredient(ingredient.name),
                                  ingredient: ingredient);
                            })
                      ],
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //use ClipRRect to clip its child. (Clip rounded rectangle)
      floatingActionButton: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 138, 138, 138)
                  .withOpacity(0.2), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 10, // Blur radius
              offset: const Offset(2, 4), // Offset in the x, y direction
            ),
          ],
        ),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const suggestedIngredientPage(),
                  ));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            backgroundColor: const Color(0xFFF83015),
            elevation: 10,
            splashColor: const Color.fromARGB(
                255, 171, 0, 0), // Set the splash color when clicked
            highlightElevation:
                8, // Set the elevation during click (higher than regular elevation)
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Find recipe',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )
                ],
              ),
            )),
      ),
    );
  }

  // void exportData() async {
  //   final CollectionReference recipes =
  //       FirebaseFirestore.instance.collection('Recipes');
  //   final csvString = await rootBundle
  //       .loadString("assets/recipeData/recipes_w_search_terms.csv");

  //   // The CsvToListConverter is not handling multiline values properly.
  //   // Use the csv.decode method from the csv package to handle multiline values correctly.
  //   List<List<dynamic>> data =
  //       const CsvToListConverter(eol: '\n').convert(csvString);

  //   for (var i = 1; i < 500; i++) {
  //     Map<String, dynamic> recipe = {
  //       "id": data[i][0].toString(),
  //       "name": data[i][1].toString(),
  //       "description": data[i][2].toString(),
  //       "ingredients": (data[i][3] as String)
  //           .replaceAll('[', '')
  //           .replaceAll(']', '')
  //           .replaceAll('\'', '')
  //           .split(', '),
  //       "ingredients_raw_str": (data[i][4] as String)
  //           .replaceAll('["', '')
  //           .replaceAll('"]', '')
  //           .split('","'),
  //       "serving_size": data[i][5].toString(),
  //       "servings": int.parse(data[i][6].toString()),
  //       "steps": (data[i][7] as String)
  //           .replaceAll('[', '')
  //           .replaceAll(']', '')
  //           .split(RegExp(r"\s*,\s*(?=(?:[^']*'[^']*')*[^']*$)"))
  //           .map((step) => step
  //               .replaceAll('\'', '')
  //               .trim()) // Remove single quotation marks and trim each step
  //           .toList(),
  //       "tags": (data[i][8] as String)
  //           .replaceAll('[', '')
  //           .replaceAll(']', '')
  //           .split(RegExp(r"\s*,\s*(?=(?:[^']*'[^']*')*[^']*$)"))
  //           .map((step) => step
  //               .replaceAll('\'', '')
  //               .replaceAll('-', ' ')
  //               .trim()) // Remove single quotation marks and trim each step
  //           .toList(),
  //       "search_terms": (data[i][9] as String)
  //           .replaceAll('{', '')
  //           .replaceAll('}', '')
  //           .split(RegExp(r"\s*,\s*(?=(?:[^']*'[^']*')*[^']*$)"))
  //           .map((step) => step
  //               .replaceAll('\'', '')
  //               .trim()) // Remove single quotation marks and trim each step
  //           .toList(),
  //     };

  //     recipes.add(recipe);
  //   }
  // }
}
