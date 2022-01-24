import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/model/user_model.dart';

class FavoriteViewController extends GetxController {
  RxList<RecipeModel> favoriteRecipes = RxList([]);
  RxList<UserModel> recipesUserData = RxList([]);

  // Rx<List<RecipeModel>>  savedRecipes  =
  removeRecipeFromFavorite(String recipeId) async {
    favoriteRecipes.removeWhere((recipe) => recipe.id == recipeId);

    await FirestoreService().removeRecipeFromFavorite(recipeId).then((value) {
      if (!value) {
        print("hellloooooooo");
        favoriteRecipes.removeWhere((recipe) => recipe.id == recipeId);
      }
    });
  }

  clearAllFavoriteRecipes() async {
    favoriteRecipes.clear();
    await FirestoreService()
        .removeAllFavoriteRecipes()
        .then((value) => favoriteRecipes.clear());
  }

  Future<void> getData() async {
    favoriteRecipes.value = await FirestoreService().getAllFavoriteRecipes();
    for (var recipe in favoriteRecipes) {
      recipesUserData
          .add(await FirestoreService().getUserData(recipe.publisherId));
    }
  }
}
