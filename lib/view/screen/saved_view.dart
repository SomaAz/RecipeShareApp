import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/saved_view_controller.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/view/widget/app_drawer.dart';
import 'package:recipes_sharing_app/view/widget/saved_recipe_card.dart';

class SavedView extends GetWidget<SavedViewController> {
  const SavedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.getData(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (controller.savedRecipes.isEmpty) {
            return Scaffold(
              body: Center(
                child: Text(
                  "You haven't added any recipes to saved yet",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Text(
                          "Saved Recipes",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.clearAllSavedRecipes();
                          },
                          child: Text(
                            "Clear",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Obx(() {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          return SavedRecipeCard(
                            controller.savedRecipes[index],
                            onDelete: () {
                              controller.removeRecipeFromSaved(
                                controller.savedRecipes[index].id,
                              );
                            },
                            userData: controller.recipesUserData[index],
                          );
                        },
                        separatorBuilder: (_, index) {
                          return SizedBox(height: 15);
                        },
                        itemCount: controller.savedRecipes.length,
                      );
                    }),
                  ],
                ),
              ),
            ),
            drawer: AppDrawer(),
          );
        });
  }
}
