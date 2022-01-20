import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';

class RecipeDetailsViewController extends GetxController {
  final RecipeModel recipe;
  PageController pageController = PageController();
  RxList<int> checkedStepsIndexes = RxList();
  RxList<int> checkedIngredientsIndexes = RxList();
  Rx<bool?> isSaved = Rx(null);
  Rx<bool?> isFavorite = Rx(null);
  Rx<int> selectedIndex = Rx(0);

  RecipeDetailsViewController(this.recipe, {bool? isSaved, bool? isFavorite}) {
    this.isSaved.value = isSaved;
    this.isFavorite.value = isFavorite;
  }
  onPageIndexChanged(int index) {
    print(index);
    selectedIndex.value = index;
  }

  //todo: Check if recipe is saved and favorite to user
  //todo: finish the favorite and saved screens
  //todo
}
