import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/model/user_model.dart';

class SavedRecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final UserModel userData;
  final void Function() onDelete;
  const SavedRecipeCard(
    this.recipe, {
    Key? key,
    required this.onDelete,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.mediaQuery.size.width,
      height: Get.mediaQuery.size.height * .14,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 1.1 / 1,
              // width: Get.mediaQuery.size.width * .35,
              // height: Get.mediaQuery.size.width * .35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  recipe.images[0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Flexible(flex: 0, child: SizedBox(width: 10)),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Container(
              // color: Colors.red,
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
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
                            userData.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        userData.username,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        getTimeSincePublished(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 0,
            child: IconButton(
              icon: Icon(
                Icons.bookmark_remove_outlined,
                size: 26,
                color: Colors.red,
              ),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }

  String getTimeSincePublished() {
    final difference = DateTime.now().difference(recipe.timePublished.toDate());
    if (difference.inHours <= 0) {
      if (difference.inMinutes <= 0) {
        return "${difference.inSeconds}secs ago";
      } else {
        return "${difference.inMinutes}min ago";
      }
    } else {
      return "${difference.inHours}hrs ago";
    }
  }
}
