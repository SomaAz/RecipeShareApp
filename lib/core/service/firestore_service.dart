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
      return Future.error(e);
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final userData = (await _usersCollection.doc(uid.trim()).get()).data();
      final model = UserModel.fromJson(userData!);
      return model;
    } catch (e) {
      print(e);

      return Future.error(e);
    }
  }

  Future<UserModel> getCurrentUserData() async {
    try {
      final currentUid = FirebaseAuthService().getCurrentUserUid();
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
              .doc(FirebaseAuthService().getCurrentUserUid())
              .collection("saved")
              .get())
          .docs
          .where((doc) => doc.exists && doc.data()["id"].toString().isNotEmpty)
          .map((doc) => doc.data()["id"])
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
          .doc(FirebaseAuthService().getCurrentUserUid())
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
      final isSaved = await checkIfRecipeIsInSaved(recipeId);
      if (!isSaved) {
        final userDocRef = _usersCollection
            .doc(FirebaseAuthService().getCurrentUserUid())
            .collection("saved")
            .doc(recipeId);
        return await userDocRef.set({"id": recipeId}).then((_) => true);
      }
      return false;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> removeRecipeFromSaved(String recipeId) async {
    try {
      return await _usersCollection
          .doc(FirebaseAuthService().getCurrentUserUid())
          .collection("saved")
          .doc(recipeId)
          .set({"id": ""}).then(
        (_) => false,
      );
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> checkIfRecipeIsInSaved(String recipeId) async {
    try {
      final ref = (_usersCollection
          .doc(FirebaseAuthService().getCurrentUserUid())
          .collection("saved")
          .doc(recipeId));
      final snapshot = await ref.get();
      return snapshot.exists
          ? snapshot.data()!["id"].toString().isNotEmpty
          : false;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<RecipeModel>> getAllFavoriteRecipes() async {
    try {
      final ids = (await _usersCollection
              .doc(FirebaseAuthService().getCurrentUserUid())
              .collection("favorite")
              .get())
          .docs
          .where((doc) => doc.exists && doc.data()["id"].toString().isNotEmpty)
          .map((doc) => doc.data()["id"])
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
      final recipeRef = _recipesCollection.doc(recipeId);
      final isFavorite = await checkIfRecipeIsInFavorite(recipeId);
      if (!isFavorite) {
        final userDocRef = _usersCollection
            .doc(FirebaseAuthService().getCurrentUserUid())
            .collection("favorite")
            .doc(recipeId);
        return await userDocRef.set({"id": recipeId}).then(
          (value) async {
            await recipeRef.update({"favorites": FieldValue.increment(1)});
            return true;
          },
        );
      }
      return false;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> removeRecipeFromFavorite(String recipeId) async {
    try {
      final recipeRef = _recipesCollection.doc(recipeId);

      return await _usersCollection
          .doc(FirebaseAuthService().getCurrentUserUid())
          .collection("favorite")
          .doc(recipeId)
          .set({"id": ""}).then(
        (value) async {
          final numberOfFavorites =
              (await recipeRef.get()).data()!["favorites"];
          if (numberOfFavorites > 0) {
            await recipeRef.update({"favorites": FieldValue.increment(-1)});
          }
          return false;
        },
      );
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> checkIfRecipeIsInFavorite(String recipeId) async {
    try {
      final ref = (_usersCollection
          .doc(FirebaseAuthService().getCurrentUserUid())
          .collection("favorite")
          .doc(recipeId));
      final snapshot = await ref.get();
      return snapshot.exists
          ? snapshot.data()!["id"].toString().isNotEmpty
          : false;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<void> removeAllFavoriteRecipes() async {
    try {
      (await _usersCollection
          .doc(FirebaseAuthService().getCurrentUserUid())
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

  Future<List<RecipeModel>> getAllPostedRecipesOfUser(String uid) async {
    try {
      final snapshot = await _firestore
          .collection("recipes")
          .where("publisherId", isEqualTo: uid.trim())
          .orderBy("timePublished", descending: true)
          .get();
      return snapshot.docs
          .map((doc) => RecipeModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<RecipeModel>> getAllPostedRecipesOfCurrentUser() async {
    try {
      return await getAllPostedRecipesOfUser(
        FirebaseAuthService().getCurrentUserUid(),
      );
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}

// //todo: change the system of favorite and saved recipes to the recipe itself
// //todo: make it depend on adding the name of the users that are
// //todo: favoring or saving the recipe in an array in the recipe document
