import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/recipe_details_view_controller.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/view/widget/custom_buttons.dart';
import 'package:recipes_sharing_app/view/widget/custom_check_box.dart';

class IngredientsView extends GetWidget<RecipeDetailsViewController> {
  final RecipeModel recipe;
  const IngredientsView(this.recipe, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.mediaQuery.size.height * .26,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      recipe.images[0],
                      fit: BoxFit.cover,
                    ),
                    Container(color: Colors.black.withOpacity(.45)),
                    SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.close_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Buy the Ingredients",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${recipe.ingredients.length} ingredients",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${controller.checkedIngredientsIndexes.length}/${recipe.ingredients.length}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        // fontWeight: FontWeight.bold,
                                        // fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.checkedIngredientsIndexes.clear();
                      },
                      child: Text(
                        "clear",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return CustomCheckBox(
                          value: controller.checkedIngredientsIndexes
                              .contains(index),
                          checkBoxText: "${index + 1}",
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(recipe.ingredients[index]["ingredient"]!),
                                Text(recipe.ingredients[index]["quantity"]!),
                              ],
                            ),
                          ),
                          text: "",
                          onChanged: (val) {
                            if (controller.checkedIngredientsIndexes
                                .contains(index)) {
                              controller.checkedIngredientsIndexes
                                  .remove(index);
                            } else {
                              controller.checkedIngredientsIndexes.add(index);
                            }
                            // controller.update();

                            print(controller.checkedIngredientsIndexes);
                          },
                        );
                      },
                      itemCount: recipe.ingredients.length,
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CustomPrimaryButton(
                        text: "Done",
                        onPressed: () {
                          if (controller.checkedIngredientsIndexes.length !=
                              recipe.ingredients.length) {
                            Get.defaultDialog(
                              middleText:
                                  "You haven't buy all the ingredients, you have just bought ${controller.checkedIngredientsIndexes.length}/${recipe.ingredients.length} ingredients",
                              confirmTextColor: Colors.white,
                              onConfirm: () {
                                print("confirm");
                                Get.back();
                                Get.back();
                              },
                              onCancel: () {
                                // Get.back();
                              },
                            );
                          } else {
                            Get.back();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
