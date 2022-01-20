import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/view/screen/recipe_details_view/recipe_details_view.dart';

class PopularRecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  const PopularRecipeCard(this.recipe, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RecipeDetailsView(recipe));
      },
      child: Container(
        width: Get.mediaQuery.size.width * .42,
        height: Get.mediaQuery.size.width * .35,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: Colors.grey.shade50,
            offset: Offset(1, 0),
          ),
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  recipe.images[0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              // height: 0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              child: Text(
                recipe.name,
                style: TextStyle(
                  // color: Colors.b,
                  fontWeight: FontWeight.w500,
                  // fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
