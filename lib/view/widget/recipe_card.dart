import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/model/user_model.dart';
import 'package:recipes_sharing_app/view/screen/recipe_details_view/recipe_details_view.dart';

class RecipeCard extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeCard(
    this.recipe, {
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  UserModel? userData;

  bool? isSaved;
  bool? isFavorite;
  // final Widget buildWidget = ;
  bool isInited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.mediaQuery.size.height * .5,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
        BoxShadow(
          blurRadius: 1,
          color: Colors.grey.shade50,
          offset: Offset(1, 0),
        ),
      ]),
      child: FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          // if (userData != null && isSaved != null) {
          //   print(userData);
          //   return buildWidget;
          // }

          if (snapshot.connectionState == ConnectionState.waiting &&
              !isInited) {
            isInited = true;

            // if (userData != null && isSaved != null && isFavorite != null) {
            //   // print(isSaved);
            //   // print(isFavorite);
            //   return _StaticRecipeCard(
            //     widget.recipe,
            //     userData: userData!,
            //     isSaved: isSaved!,
            //     isFavorite: isFavorite!,
            //     onFavorite: () async {
            //       setState(() {
            //         print(isFavorite);
            //         isFavorite!
            //             ? FirestoreService()
            //                 .removeRecipeFromFavorite(
            //                   widget.recipe.id,
            //                 )
            //                 .then((value) => isFavorite = value)
            //             : FirestoreService()
            //                 .addRecipeToFavorite(
            //                   widget.recipe.id,
            //                 )
            //                 .then((value) => isFavorite = value);
            //       });
            //     },
            //     onSaved: () async {
            //       setState(
            //         () {
            //           isSaved!
            //               ? FirestoreService()
            //                   .removeRecipeFromSaved(
            //                     widget.recipe.id,
            //                   )
            //                   .then((value) => isSaved = value)
            //               : FirestoreService()
            //                   .addRecipeToSaved(
            //                     widget.recipe.id,
            //                   )
            //                   .then((value) => isSaved = value);
            //         },
            //       );
            //     },
            //   );
            // }

            return Center(
              child: CircularProgressIndicator(),
            );
          }

          userData = snapshot.data!['userModel'] as UserModel;
          isSaved = snapshot.data!['isSaved'] as bool;
          isFavorite = snapshot.data!['isFavorite'] as bool;

          return _StaticRecipeCard(
            widget.recipe,
            userData: userData!,
            isSaved: isSaved!,
            isFavorite: isFavorite!,
            onFavorite: () async {
              setState(
                () {
                  isFavorite!
                      ? FirestoreService()
                          .removeRecipeFromFavorite(
                            widget.recipe.id,
                          )
                          .then((value) => isFavorite = value)
                      : FirestoreService()
                          .addRecipeToFavorite(
                            widget.recipe.id,
                          )
                          .then((value) => isFavorite = value);
                },
              );
            },
            onSaved: () async {
              setState(
                () {
                  isSaved!
                      ? FirestoreService()
                          .removeRecipeFromSaved(
                            widget.recipe.id,
                          )
                          .then((value) => isSaved = value)
                      : FirestoreService()
                          .addRecipeToSaved(
                            widget.recipe.id,
                          )
                          .then((value) => isSaved = value);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<Map> getData() async {
    return {
      "userModel":
          await FirestoreService().getUserData(widget.recipe.publisherId),
      "isSaved":
          await FirestoreService().checkIfRecipeIsInSaved(widget.recipe.id),
      "isFavorite":
          await FirestoreService().checkIfRecipeIsInFavorite(widget.recipe.id),
    };
  }
}

class _StaticRecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final UserModel userData;
  final bool isSaved;
  final bool isFavorite;
  final void Function() onSaved;
  final void Function() onFavorite;
  const _StaticRecipeCard(
    this.recipe, {
    Key? key,
    required this.userData,
    required this.isSaved,
    required this.onSaved,
    required this.isFavorite,
    required this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => RecipeDetailsView(
            recipe,
            userData: userData,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: recipe.id,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.network(
                      recipe.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Container(color: Colors.white),
                Container(
                  // color: Colors.black.withOpacity(.2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(.7),
                        Colors.black.withOpacity(.01),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildIconButton(
                              Icons.favorite_border_outlined,
                              onPressed: onFavorite,
                              isActive: isFavorite,
                              activeIcon: Icons.favorite,
                              activeColor: Colors.red,
                            ),
                            SizedBox(height: 10),
                            buildIconButton(
                              Icons.bookmark_border_outlined,
                              onPressed: onSaved,
                              isActive: isSaved,
                              activeIcon: Icons.bookmark,
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              recipe.tags.reduce(
                                (value, element) => "$value • $element ",
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              children: [
                                Icon(Icons.filter, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  recipe.images.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    // color: Colors.b,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
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
                              userData.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          userData.username,
                          style: TextStyle(
                            fontSize: 14,
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildInfoTexts(
                        "ingredients", recipe.ingredients.length.toString()),
                    SizedBox(width: 10),
                    buildInfoTexts(
                        "cooking time", "${recipe.cookTime.inMinutes}min"),
                    SizedBox(width: 10),
                    buildInfoTexts("serves", recipe.serves.toString()),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "price",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "${recipe.priceRange.start.toInt()}\$-${recipe.priceRange.end.toInt()}\$",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // buildIconWithText(Icons.,""),
                  ],
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoTexts(String infoTitle, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          infoTitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        SizedBox(width: 4),
        Text(
          info,
        ),
      ],
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

  buildIconButton(
    IconData icon, {
    bool isActive = false,
    void Function()? onPressed,
    IconData? activeIcon,
    Color? activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Get.mediaQuery.size.width),
      ),
      child: InkWell(
        onTap: onPressed,
        // borderRadius: BorderRadius.circular(Get.mediaQuery.size.width),
        overlayColor: MaterialStateProperty.all(Colors.yellow),
        child: Icon(
          isActive ? activeIcon ?? icon : icon,
          color: isActive
              ? activeColor ?? Colors.grey.shade900
              : Colors.grey.shade900,
        ),
      ),
    );
  }
}
