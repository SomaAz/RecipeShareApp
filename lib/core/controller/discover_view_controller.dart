import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/cateogry_model.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/model/user_model.dart';

class DiscoverViewController extends GetxController {
  //setters
  List<RecipeModel> _recipes = [];
  List<CategoryModel> _categories = [];
  List<RecipeModel> _popularRecipes = [];
  List<RecipeModel> _latestRecipes = [];
  UserModel? _currentUser;
  //getters
  UserModel? get currentUser => _currentUser;
  List<RecipeModel> get recipes => _recipes;
  List<CategoryModel> get categories => _categories;
  List<RecipeModel> get popularRecipes => _popularRecipes;
  List<RecipeModel> get latestRecipes => _latestRecipes;

  Future<void> _getData() async {
    _currentUser = await FirestoreService().getCurrentUserData();
    _categories = await FirestoreService().getAllCategories();
    _recipes = await FirestoreService().getAllRecipes().then((recipes) async {
      _popularRecipes = recipes.where((recipe) {
        return recipe.favorites > recipes.map((e) => e.favorites).average;
      }).toList();
      _latestRecipes = recipes.where((recipe) {
        return recipe.timePublished
                .toDate()
                .difference(DateTime.now())
                .inHours <=
            48;
      }).toList();
      return recipes;
    });
  }

  Future<void> getData() async {
    await _getData().then((value) => update());
  }
}
