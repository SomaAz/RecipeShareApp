import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/recipe_details_view_controller.dart';
import 'package:recipes_sharing_app/model/recipe_model.dart';
import 'package:recipes_sharing_app/view/widget/custom_buttons.dart';
import 'package:recipes_sharing_app/view/widget/custom_check_box.dart';

class CookingView extends GetWidget<RecipeDetailsViewController> {
  final RecipeModel recipe;
  const CookingView(this.recipe, {Key? key}) : super(key: key);

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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      recipe.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${recipe.cookTime.inMinutes}min",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
                                          "Start Cooking",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${recipe.steps.length} steps",
                                          style: TextStyle(
                                            color: Colors.white,
                                            // fontWeight: FontWeight.bold,
                                            // fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${controller.checkedStepsIndexes.length}/${recipe.steps.length}",
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
                    // SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        controller.checkedStepsIndexes.clear();
                      },
                      child: Text(
                        "clear",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return CustomCheckBox(
                          value: controller.checkedStepsIndexes.contains(index),
                          checkBoxText: "${index + 1}",
                          text: recipe.steps[index],
                          onChanged: (val) {
                            if (controller.checkedStepsIndexes
                                .contains(index)) {
                              controller.checkedStepsIndexes.remove(index);
                            } else {
                              controller.checkedStepsIndexes.add(index);
                            }
                          },
                        );
                      },
                      separatorBuilder: (_, index) {
                        // return SizedBox();
                        return Container(
                          height: 30,
                          width: 30,
                          padding: const EdgeInsets.only(left: 10),
                          // color: Colors.blue,
                          alignment: Alignment.centerLeft,
                          child: VerticalDivider(
                            thickness: 2,
                            indent: 0,
                            width: 10,
                            color:
                                controller.checkedStepsIndexes.contains(index)
                                    ? Get.theme.primaryColor
                                    : Colors.grey.shade600,
                            // color: Colors. ,
                          ),
                        );
                      },
                      itemCount: recipe.steps.length,
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CustomPrimaryButton(
                        text: "Finish",
                        onPressed: () {
                          if (controller.checkedStepsIndexes.length !=
                              recipe.steps.length) {
                            Get.defaultDialog(
                              confirmTextColor: Colors.white,
                              middleText:
                                  "You haven't finish all the steps, you have just finished ${controller.checkedStepsIndexes.length}/${recipe.steps.length} steps",
                              onConfirm: () {
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
