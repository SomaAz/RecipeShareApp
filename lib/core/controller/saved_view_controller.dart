import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/model/user_model.dart';

class SavedViewController extends GetxController {
  RxList<RecipeModel> savedRecipes = RxList([]);
  RxList<UserModel> recipesUserData = RxList([]);
  // Rx<List<RecipeModel>>  savedRecipes  =
  removeRecipeFromSaved(String recipeId) async {
    await FirestoreService().removeRecipeFromSaved(recipeId).then(
      (value) {
        if (!value) {
          print("hellloooooooo");
          savedRecipes.removeWhere((recipe) => recipe.id == recipeId);
        }
      },
    );
  }

  clearAllSavedRecipes() async {
    await FirestoreService()
        .removeAllSavedRecipes()
        .then((value) => savedRecipes.clear());
  }

  Future<void> getData() async {
    savedRecipes.value = await FirestoreService().getAllSavedRecipes();
    for (var recipe in savedRecipes) {
      recipesUserData
          .add(await FirestoreService().getUserData(recipe.publisherId));
    }
  }
}
