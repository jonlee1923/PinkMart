import 'dart:convert';
import '../models/recipe.dart';
import 'package:http/http.dart' as http;

// API manager class for the Edamam Recipe API.
class EdamamApiManager {
  static Future<List<Recipe>> getRecipes(String query) async {
    List<Recipe> recipes = [];
    String url =
        'https://api.edamam.com/api/recipes/v2?type=public&q=$query&app_id=d83c015e&app_key=2c91df921d1dd1e40e3ea97f796881ca';

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        //print(jsonData['hits'].length);

        jsonData['hits'].forEach((element) {
          if (element['recipe']['url'] != null &&
              element['recipe']['image'] != null) {
            Recipe recipeModel = Recipe(
              label: element['recipe']['label'],
              image: element['recipe']['image'],
              source: element['recipe']['source'],
              ingredients: element['recipe']['ingredientLines'],
            );
            //print(recipeModel.image);
            //print(recipeModel.ingredients);
            recipes.add(recipeModel);
          }
        });
        return recipes;
      } else {
        return List<Recipe>();
      }
    } catch (error) {
      return List<Recipe>();
    }
  }
}
