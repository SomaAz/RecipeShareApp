import 'package:get/get.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/model/user_model.dart';

class ProfileViewController extends GetxController {
  UserModel? userData;
  List<RecipeModel> postedRecipes = [];
}
