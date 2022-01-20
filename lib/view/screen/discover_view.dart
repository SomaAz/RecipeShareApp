import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/discover_view_controller.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/view/widget/app_drawer.dart';
import 'package:recipes_sharing_app/view/widget/category_card.dart';
import 'package:recipes_sharing_app/view/widget/popular_recipe_card.dart';
import 'package:recipes_sharing_app/view/widget/recipe_card.dart';

class DiscoverView extends GetWidget<DiscoverViewController> {
  const DiscoverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.getData(),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return RefreshIndicator(
              onRefresh: () async => controller.getData(),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          // if (snapshot.hasError) {
          //   print(snapshot.error);
          //   return Center(
          //     child: Text("Oops! There is an error happend,try again"),
          //   );
          // }
          return GetBuilder<DiscoverViewController>(builder: (controller) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: controller.currentUser == null
                        ? SizedBox()
                        : SizedBox(
                            width: 35,
                            height: 35,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Get.mediaQuery.size.width,
                              ),
                              child: Image.network(
                                controller.currentUser!.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async => controller.getData(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Discover Recipes",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Best food recipes you can find.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Search for Recipes",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Get.theme.primaryColor,
                                // width: 1,
                              ),
                            ),
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text("Filter "),
                              Icon(Icons.tune),
                            ],
                          ),
                        ),
                        // SizedBox(height: 25),
                        buildSubtitle("Categories"),
                        SizedBox(height: 20),
                        SizedBox(
                          height: Get.mediaQuery.size.width * .22,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              return CategoryCard(controller.categories[index]);
                            },
                            separatorBuilder: (_, index) {
                              return SizedBox(width: 10);
                            },
                            itemCount: controller.categories.length,
                          ),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildSubtitle("Popular Recipes"),
                            TextButton(
                              onPressed: () {
                                FirestoreService().getAllRecipes();
                              },
                              child: Text(
                                  "+${controller.popularRecipes.length} All"),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: Get.mediaQuery.size.width * .35,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              return PopularRecipeCard(
                                controller.popularRecipes[index],
                              );
                            },
                            separatorBuilder: (_, index) {
                              return SizedBox(width: 10);
                            },
                            itemCount: controller.popularRecipes.length,
                          ),
                        ),
                        SizedBox(height: 25),
                        buildSubtitle("Latest Recipes"),
                        SizedBox(height: 20),
                        ListView.separated(
                          // scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return RecipeCard(controller.latestRecipes[index]);
                          },
                          separatorBuilder: (_, index) {
                            return SizedBox(height: 20);
                          },
                          itemCount: controller.latestRecipes.length,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              drawer: AppDrawer(),
            );
          });
        });
  }
} //•

buildSubtitle(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade900,
    ),
  );
}
