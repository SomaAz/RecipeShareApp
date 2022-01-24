import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:recipes_sharing_app/core/service/firebase_auth_service.dart';
import 'package:recipes_sharing_app/model/cateogry_model.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/model/user_model.dart';

class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;
  static final _recipesCollection = _firestore.collection("recipes");
  static final _categoriesCollection = _firestore.collection("categories");
  static final _usersCollection = _firestore.collection("users");
  Future<void> addUserToFirestore(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toJson());
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final userData = (await _usersCollection.doc(uid).get()).data()!;

      return UserModel.fromJson(
        userData,
      );
    } catch (e) {
      print(e);

      return Future.error(e);
    }
  }

  Future<UserModel> getCurrentUserData() async {
    try {
      final currentUid = await FirebaseAuthService().getCurrentUserUid();
      return await getUserData(currentUid);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final docs = (await _recipesCollection.get()).docs;

      final recipes = docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        // data['cookTime'] = Duration(seconds: data['cookTime']);
        // data['images'] = (data['images'] as List).cast<String>();
        // data['tags'] = (data['tags'] as List).cast<String>();
        // data['steps'] = (data['steps'] as List).cast<String>();
        // data['priceRange'] = RangeValues(
        //   double.parse((data['priceRange'] as String).split("-")[0]),
        //   double.parse((data['priceRange'] as String).split("-")[1]),
        // );
        // data['ingredients'] =
        //     (data['ingredients'] as List).cast<String>().map((ing) {
        //   final ingList = ing.split(">");

        //   return {
        //     "ingredient": ingList[0],
        //     "quantity": ingList[1],
        //   };
        // }).toList();
        return RecipeModel.fromJson(data);
      }).toList();
      return recipes;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<RecipeModel> getRecipeOfId(String recipeId) async {
    try {
      return RecipeModel.fromJson(
        (await _recipesCollection.doc(recipeId).get()).data()!,
      );
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      return (await _categoriesCollection.get())
          .docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<RecipeModel>> getAllSavedRecipes() async {
    try {
      final ids = (await _usersCollection
              .doc(await FirebaseAuthService().getCurrentUserUid())
              .collection("saved")
              .get())
          .docs
          .map((doc) => doc.id)
          .toList();
      final List<RecipeModel> recipes = [];
      for (String id in ids) {
        recipes.add(await getRecipeOfId(id));
      }
      return recipes;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<void> removeAllSavedRecipes() async {
    try {
      (await _usersCollection
          .doc(await FirebaseAuthService().getCurrentUserUid())
          .collection("saved")
          .get()
          .then(
        (snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete();
          }
        },
      ));
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> addRecipeToSaved(String recipeId) async {
    try {
      return _usersCollection
          .doc(await FirebaseAuthService().getCurrentUserUid())
          .collection("saved")
          .doc(recipeId)
          .set({"id": recipeId}).then((value) => true);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> removeRecipeFromSaved(String recipeId) async {
    try {
      return _usersCollection
          .doc(await FirebaseAuthService().getCurrentUserUid())
          .collection("saved")
          .doc(recipeId)
          .delete()
          .then((value) => false);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> checkIfRecipeIsInSaved(String recipeId) async {
    try {
      return (await _usersCollection
              .doc(await FirebaseAuthService().getCurrentUserUid())
              .collection("saved")
              .doc(recipeId)
              .get())
          .exists;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<RecipeModel>> getAllFavoriteRecipes() async {
    try {
      final ids = (await _usersCollection
              .doc(await FirebaseAuthService().getCurrentUserUid())
              .collection("favorite")
              .get())
          .docs
          .map((doc) => doc.id)
          .toList();
      final List<RecipeModel> recipes = [];
      for (String id in ids) {
        recipes.add(await getRecipeOfId(id));
      }
      return recipes;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> addRecipeToFavorite(String recipeId) async {
    try {
      return _usersCollection
          .doc(await FirebaseAuthService().getCurrentUserUid())
          .collection("favorite")
          .doc(recipeId)
          .set({"id": recipeId}).then((value) => true);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> removeRecipeFromFavorite(String recipeId) async {
    try {
      return _usersCollection
          .doc(await FirebaseAuthService().getCurrentUserUid())
          .collection("favorite")
          .doc(recipeId)
          .delete()
          .then((value) => false);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> checkIfRecipeIsInFavorite(String recipeId) async {
    try {
      return (await _usersCollection
              .doc(await FirebaseAuthService().getCurrentUserUid())
              .collection("favorite")
              .doc(recipeId)
              .get())
          .exists;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<void> removeAllFavoriteRecipes() async {
    try {
      (await _usersCollection
          .doc(await FirebaseAuthService().getCurrentUserUid())
          .collection("favorite")
          .get()
          .then(
        (snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete();
          }
        },
      ));
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<RecipeModel>> getAllRecipesOfCategory(
      CategoryModel category) async {
    try {
      return (await _recipesCollection
              .where("category", isEqualTo: category.name)
              .get())
          .docs
          .map((doc) => RecipeModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<RecipeModel>> getPopularRecipes() async {
    try {
      final recipes = (await _recipesCollection.get())
          .docs
          .map(
            (doc) => RecipeModel.fromJson(doc.data()),
          )
          .toList();

      final popularRecipes = recipes.where(
        (recipe) {
          return recipe.favorites > recipes.map((e) => e.favorites).average;
        },
      ).toList();

      return popularRecipes;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
