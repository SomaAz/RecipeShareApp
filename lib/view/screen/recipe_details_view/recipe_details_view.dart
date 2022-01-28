import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/recipe_details_view_controller.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/model/user_model.dart';
import 'package:recipes_sharing_app/view/screen/recipe_details_view/cooking_view.dart';
import 'package:recipes_sharing_app/view/screen/recipe_details_view/ingredients_view.dart';
import 'package:recipes_sharing_app/view/widget/custom_buttons.dart';

class RecipeDetailsView extends GetWidget<RecipeDetailsViewController> {
  final RecipeModel recipe;
  UserModel? userData;
  // final bool? isSaved;
  // final bool? isFavorite;
  RecipeDetailsView(this.recipe, {Key? key, this.userData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeDetailsViewController>(
        init: Get.put(RecipeDetailsViewController(recipe)),
        builder: (controller) {
          return FutureBuilder(
              future: getData(),
              builder: (context, AsyncSnapshot<Map> snapshot) {
                // if (isSaved == null) {}

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                controller.isSaved.value = snapshot.data!['isSaved'];
                controller.isFavorite.value = snapshot.data!['isFavorite'];
                userData ??= userData = snapshot.data!["userData"];

                return Obx(() {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      actions: [
                        IconButton(
                          onPressed: () async {
                            controller.isFavorite.value =
                                !controller.isFavorite.value!;

                            !controller.isFavorite.value!
                                ? await FirestoreService()
                                    .removeRecipeFromFavorite(recipe.id)
                                // .then(
                                //   (value) =>
                                //       controller.isFavorite.value = value,
                                // )
                                : await FirestoreService()
                                    .addRecipeToFavorite(recipe.id);
                            // .
                          },
                          icon: Icon(
                            controller.isFavorite.value!
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: controller.isFavorite.value!
                                ? Colors.red
                                : Colors.grey.shade900,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            controller.isSaved.value =
                                !controller.isSaved.value!;
                            !controller.isSaved.value!
                                ? await FirestoreService()
                                    .removeRecipeFromSaved(recipe.id)
                                // .then(
                                //   (value) =>
                                //       controller.isSaved.value = value,
                                // )
                                : await FirestoreService()
                                    .addRecipeToSaved(recipe.id);
                            // .then(
                            //   (value) =>
                            //       controller.isSaved.value = value,
                            // );
                            // controller.update();
                          },
                          icon: Icon(
                            controller.isSaved.value!
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            color: controller.isSaved.value!
                                ? Colors.green
                                : Colors.grey.shade900,
                          ),
                        ),
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              recipe.category.replaceFirst(
                                recipe.category[0],
                                recipe.category[0].toUpperCase(),
                              ),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 34,
                                      height: 34,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          Get.mediaQuery.size.width,
                                        ),
                                        child: Image.network(
                                          userData!.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      userData!.username,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 12),
                                Text(
                                  ".${getTimeSincePublished()}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Hero(
                              tag: recipe.id,
                              child: SizedBox(
                                width: Get.mediaQuery.size.width,
                                height: Get.mediaQuery.size.height * .3,
                                child: PageView.builder(
                                  controller: controller.pageController,
                                  onPageChanged: controller.onPageIndexChanged,
                                  itemBuilder: (_, index) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      // margin: const EdgeInsets.only(right: 8),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              recipe.images[index],
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: recipe.images.length,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            PageViewIndicator(
                              selectedIndex: controller.selectedIndex.value,
                              itemCount: recipe.images.length,
                            ),
                            SizedBox(height: 15),
                            buildSubtitleText("Description"),
                            Text(
                              recipe.description,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 20),
                            buildSubtitleText("Cooking Steps"),
                            SizedBox(height: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "${recipe.steps[0]},${recipe.steps[1].isBlank! ? "" : recipe.steps[1]}...",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " more",
                                    style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.to(() => CookingView(recipe));
                                      },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    buildSubtitleText("Ingredients"),
                                    Text(
                                      "${recipe.ingredients.length} Ingredients",
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    )
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.to(() => IngredientsView(recipe));
                                  },
                                  child: Text(
                                    "Start Buying",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "${recipe.ingredients[index]["ingredient"]}",
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: recipe.ingredients.length,
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: CustomPrimaryButton(
                                text: "Start Cooking",
                                onPressed: () {
                                  Get.to(() => CookingView(recipe));
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              });
        });
  }

  String getTimeSincePublished() {
    final difference = DateTime.now().difference(recipe.timePublished.toDate());
    if (difference.inDays <= 0) {
      if (difference.inHours <= 0) {
        if (difference.inMinutes <= 0) {
          return "${difference.inSeconds}secs ago";
        } else {
          return "${difference.inMinutes}min ago";
        }
      } else {
        return "${difference.inHours}hrs ago";
      }
    } else {
      return "${difference.inDays}days ago";
    }
  }

  Future<Map> getData() async {
    print(userData == null);
    final ud = await FirestoreService().getUserData(recipe.publisherId);
    print(ud.username);
    return {
      "userData": ud,
      "isSaved": await FirestoreService().checkIfRecipeIsInSaved(recipe.id),
      "isFavorite":
          await FirestoreService().checkIfRecipeIsInFavorite(recipe.id),
    };
  }
}

Widget buildSubtitleText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
  );
}

class PageViewIndicator extends StatelessWidget {
  PageViewIndicator({
    Key? key,
    required this.selectedIndex,
    this.itemCount = 0,
  }) : super(key: key);

  /// PageView Controller
  final int selectedIndex;

  /// Number of indicators
  final int itemCount;

  /// Ordinary colours
  final Color normalColor = Colors.grey.shade300;

  final Color selectedColor = Get.theme.primaryColor;

  /// Size of points
  final double size = 10;
  // final double size = 8.0;

  /// Spacing of points
  final double spacing = 2.0;
  Widget _buildIndicator(
      int index, int pageCount, double dotSize, double spacing) {
    // Is the current page selected?

    // print(controller);
    bool isCurrentPageSelected = index == (selectedIndex);

    return SizedBox(
      height: size,
      width: size + (2 * spacing),
      child: Center(
        child: Material(
          color: isCurrentPageSelected ? selectedColor : normalColor,
          type: MaterialType.circle,
          child: SizedBox(
            width: dotSize,
            height: dotSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(itemCount, (int index) {
          return _buildIndicator(index, itemCount, size, spacing);
        }),
      ),
    );
  }
}
