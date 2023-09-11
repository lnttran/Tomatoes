import 'dart:convert';
import 'package:http/http.dart';
import 'package:tomatoes/Components/recipe.dart';

class HttpService {
  Future<List<Recipe>> getRecipes(int start, int to) async {
    final String queryString =
        Uri(queryParameters: {'start': start.toString(), 'to': to.toString()})
            .query;

    final String requestUrl =
        "https://script.google.com/macros/s/AKfycbxclRvqUIzo2iyuby-FeH_6dOdGyAVsPynJgakJ_2i_SpH0tBGO6S6KMB9gfohb9lagSA/exec?" +
            queryString;
    final Uri recipesURL = Uri.parse(requestUrl);

    Response res = await get(recipesURL);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)["data"];

      List<Recipe> recipes = body
          .map(
            (dynamic item) => Recipe.fromJson(item),
          )
          .toList();

      return recipes;
    } else {
      throw "Unable to retrieve posts.";
    }
  }
}
