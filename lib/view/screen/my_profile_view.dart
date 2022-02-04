import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/profile_view_controller.dart';
import 'package:recipes_sharing_app/core/service/firebase_auth_service.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/view/screen/post_recipe_view.dart';
import 'package:recipes_sharing_app/view/widget/app_drawer.dart';
import 'package:recipes_sharing_app/view/widget/recipe_card.dart';

class MyProfileView extends GetWidget<ProfileViewController> {
  const MyProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileViewController>(
      init: ProfileViewController(),
      builder: (controller) {
        return FutureBuilder(
          future: getData(controller),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Scaffold(
                  body: Center(
                    child: Text("There is an error"),
                  ),
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                );
              }

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                        onPressed: () {
                          Get.to(() => PostRecipeView());
                        },
                        icon: Icon(Icons.add))
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Profile",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Get.mediaQuery.size.width * .3,
                              height: Get.mediaQuery.size.width * .3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Get.mediaQuery.size.height),
                                child: Image.network(
                                  controller.userData!.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SizedBox(height: 10),
                                Text(
                                  controller.userData!.username,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                                // Text(
                                //   "${userData.email}",
                                //   style: TextStyle(
                                //     color: Colors.grey.shade700,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),
                                Text(
                                  "posts: ${controller.userData!.posts}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Posts",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return RecipeCard(controller.postedRecipes[index]);
                          },
                          separatorBuilder: (_, index) {
                            return SizedBox(height: 15);
                          },
                          itemCount: controller.postedRecipes.length,
                        ),
                      ],
                    ),
                  ),
                ),
                // drawer: AppDrawer(),
                drawer: AppDrawer(),
              );
            }
          },
        );
      },
    );
  }

  Future<void> getData(ProfileViewController controller) async {
    try {
      controller.userData = await FirestoreService()
          .getUserData(FirebaseAuthService().getCurrentUserUid());
      controller.postedRecipes = await FirestoreService()
          .getAllPostedRecipesOfUser(FirebaseAuthService().getCurrentUserUid());
    } catch (e) {
      print(e);
    }
  }
}
