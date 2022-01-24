import 'package:flutter/material.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/view/widget/recipe_card.dart';

class PopularRecipesView extends StatelessWidget {
  const PopularRecipesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: FirestoreService().getPopularRecipes(),
          builder: (_, AsyncSnapshot<List<RecipeModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final recipes = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Popular Recipes",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.separated(
                      // scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return RecipeCard(recipes[index]);
                      },
                      separatorBuilder: (_, index) {
                        return SizedBox(height: 20);
                      },
                      itemCount: recipes.length,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
