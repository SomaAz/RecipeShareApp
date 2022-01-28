import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/cateogry_model.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/model/user_model.dart';

class DiscoverViewController extends GetxController {
  //setters
  RxList<RecipeModel> _recipes = RxList([]);
  RxList<CategoryModel> _categories = RxList([]);
  RxList<RecipeModel> _popularRecipes = RxList([]);
  RxList<RecipeModel> _latestRecipes = RxList([]);
  UserModel? _currentUser;
  //getters
  UserModel? get currentUser => _currentUser;
  RxList<RecipeModel> get recipes => _recipes;
  RxList<CategoryModel> get categories => _categories;
  RxList<RecipeModel> get popularRecipes => _popularRecipes;
  RxList<RecipeModel> get latestRecipes => _latestRecipes;

  Future<void> _getData() async {
    _currentUser = await FirestoreService().getCurrentUserData();
    _categories = RxList(await FirestoreService().getAllCategories());
    _recipes = await FirestoreService().getAllRecipes().then((recipes) async {
      _popularRecipes = RxList(
        recipes.where((recipe) {
          return recipe.favorites > recipes.map((e) => e.favorites).average;
        }).toList(),
      );
      _latestRecipes = RxList(
        recipes.where((recipe) {
          return DateTime.now()
                  .difference(recipe.timePublished.toDate())
                  .inHours <=
              48;
        }).toList(),
      );
      return RxList(recipes);
    });
  }

  Future<void> getData() async {
    await _getData();
  }

  updateData() async {
    await _getData().then((value) => update());
  }
}
