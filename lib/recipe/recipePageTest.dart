import 'package:flutter/material.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/service/http_service.dart';

class RecipePageTest extends StatelessWidget {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
      ),
      body: FutureBuilder(
        future: httpService.getRecipes(0, 10),
        builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.hasData) {
            List<Recipe> recipes = snapshot.data!;
            return ListView(
              children: recipes
                  .map(
                    (Recipe recipe) => ListTile(
                      title: Text(recipe.name),
                      subtitle: Text(recipe.description),
                    ),
                  )
                  .toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
