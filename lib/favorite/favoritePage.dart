import 'package:flutter/material.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/recipe/recipeCard.dart';
import 'package:tomatoes/service/http_service.dart';

class favoritePage extends StatefulWidget {
  const favoritePage({super.key});

  @override
  State<favoritePage> createState() => _favoritePageState();
}

class _favoritePageState extends State<favoritePage> {
  final HttpService httpService = HttpService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
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
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                future: httpService.getRecipes(0, 10),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Recipe>> snapshot) {
                  if (snapshot.hasData) {
                    List<Recipe> recipes = snapshot.data!;
                    return ListView(
                      children: recipes
                          .map(
                            (Recipe recipe) => Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: recipeCard(
                                recentlyView: false,
                                recipe: recipe,
                                isFave: true,
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
          ],
        ),
      ),
    );
  }
}
