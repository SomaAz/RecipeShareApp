import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/post_view_controller.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/cateogry_model.dart';
import 'package:recipes_sharing_app/view/widget/custom_buttons.dart';

class PostRecipeView extends GetWidget<PostViewController> {
  const PostRecipeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostViewController>(
        init: Get.put(PostViewController()),
        builder: (controller) {
          return FutureBuilder(
              future: FirestoreService().getAllCategories(),
              builder: (_, AsyncSnapshot<List<CategoryModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                controller.category.value = snapshot.data![0].name;
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  body: Obx(() {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Post",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            SizedBox(height: 20),
                            controller.images.isEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      controller.getMuiltipeImages();
                                    },
                                    child: DottedBorder(
                                      radius: Radius.circular(15),
                                      borderType: BorderType.RRect,
                                      dashPattern: const [5, 3],
                                      color: Colors.grey,
                                      // strokeCap: StrokeCap.round,
                                      // strokeWidth: 2,
                                      child: Container(
                                        height: Get.mediaQuery.size.height * .3,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // border: Border.all(color: Colors.grey),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.camera_alt_outlined,
                                                size: 32),
                                            SizedBox(height: 6),
                                            Text(
                                              "Add photos",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "The number of photos should be at least one photo and maximum of 8 photos",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    itemBuilder: (_, index) {
                                      if (index == controller.images.length) {
                                        return GestureDetector(
                                          onTap: () {
                                            controller.getMuiltipeImages();
                                          },
                                          child: DottedBorder(
                                            radius: Radius.circular(15),
                                            borderType: BorderType.RRect,
                                            dashPattern: const [5, 3],
                                            color: Colors.grey,
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                // border: Border.all(color: Colors.grey),
                                              ),
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 24,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    "Add photos",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade700),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 4),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.file(
                                              controller.images[index],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: FloatingActionButton(
                                              backgroundColor:
                                                  Colors.white.withOpacity(.85),
                                              mini: true,
                                              child: Icon(
                                                Icons.delete_outline,
                                                size: 22,
                                                color: Colors.black
                                                    .withOpacity(.8),
                                              ),
                                              onPressed: () {
                                                controller.images
                                                    .removeAt(index);
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: controller.images.length +
                                        (controller.images.length >= 8 ? 0 : 1),
                                  ),
                            SizedBox(height: 15),
                            TextFormField(
                              decoration: InputDecoration(
                                // labelText: "Recipe name",
                                hintText: "Recipe name",
                              ),
                              onSaved: (val) {
                                if (val != null) {
                                  controller.name.value = val;
                                  controller.update();
                                }
                              },
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please enter a value for the name of the recipe";
                                }
                                if (val.trim().length > 40) {
                                  return "Please write a smaller name";
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Category",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: DropdownButton<String>(
                                items: List.generate(snapshot.data!.length,
                                    (index) {
                                  return DropdownMenuItem(
                                    child: Text(snapshot.data![index].name),
                                    value: snapshot.data![index].name,
                                  );
                                }),
                                onChanged: (val) {
                                  controller.category.value = val!;
                                },
                                value: controller.category.value,

                                // value: "dgfhf",
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Cooking Time",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Min: 1min",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  "Max: 10hr",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            SliderTheme(
                              data: SliderThemeData(
                                  // trackShape: CustomTrackShape(),
                                  ),
                              child: Slider(
                                value: controller.cookTime.value.toDouble(),
                                onChanged: (val) {
                                  controller.cookTime.value = val.toInt();
                                },
                                min: 1,
                                max: 600,
                                divisions: 600,
                                label: controller.cookTime.value.toString(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Ingredients",
                              style: TextStyle(fontSize: 18),
                            ),
                            GetX<_IngredientsAndInstructionsController>(
                                init: Get.put(
                                    _IngredientsAndInstructionsController()),
                                builder: (ingscontroller) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                        itemCount: ingscontroller
                                            .ingredientsTextControllers.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (_, index) {
                                          return Flex(
                                            // key: Key(index.toString()),
                                            direction: Axis.horizontal,
                                            children: [
                                              Flexible(
                                                flex: 6,
                                                child: TextFormField(
                                                  // initialValue: ingscontroller
                                                  //     .ingredients[index],
                                                  controller: ingscontroller
                                                          .ingredientsTextControllers[
                                                      index],
                                                  decoration: InputDecoration(
                                                    // labelText: "Ingredient",
                                                    hintText: "Ingredient",
                                                  ),

                                                  onSaved: (val) {},
                                                  validator: (val) {},
                                                  // expands: false,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Flexible(
                                                flex: 4,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    hintText: "Quantity",
                                                  ),
                                                  controller: ingscontroller
                                                          .ingredientsQuantityTextControllers[
                                                      index],
                                                  onSaved: (val) {},
                                                  validator: (val) {},
                                                  expands: false,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  ingscontroller
                                                    ..ingredientsTextControllers
                                                        .removeAt(index)
                                                    ..ingredientsQuantityTextControllers
                                                        .removeAt(index);
                                                  // print(ingscontroller
                                                  //     .ingredients);
                                                  // ingscontroller.update();
                                                },
                                                icon: const Icon(Icons.close,
                                                    size: 20),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // ingscontroller.ingredients.add("");
                                          ingscontroller
                                            ..ingredientsTextControllers
                                                .add(TextEditingController())
                                            ..ingredientsQuantityTextControllers
                                                .add(TextEditingController());
                                          // ingscontroller.update();
                                        },
                                        child: const Text("Add ingredient"),
                                      ),
                                      SizedBox(height: 20),
                                      const Text(
                                        "Instructions",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (_, index) {
                                          return Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Flexible(
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    // labelText: "Ingredient",
                                                    hintText: "Instruction",
                                                  ),
                                                  controller: ingscontroller
                                                          .instructionsTextControllers[
                                                      index],
                                                  onSaved: (val) {},
                                                  validator: (val) {},
                                                  // expands: false,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  ingscontroller
                                                      .instructionsTextControllers
                                                      .removeAt(index);
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        itemCount: ingscontroller
                                            .instructionsTextControllers.length,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ingscontroller
                                              .instructionsTextControllers
                                              .add(TextEditingController());
                                        },
                                        child: const Text("Add instruction"),
                                      ),
                                    ],
                                  );
                                }),
                            SizedBox(height: 20),
                            const Text(
                              "Tags",
                              style: TextStyle(fontSize: 18),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                // labelText: "Ingredient",
                                hintText: "Tag",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    final tag =
                                        controller.tagFieldController.text;
                                    if (!controller.tags.contains(tag) &&
                                        tag.isNotEmpty) {
                                      controller.tags.add(tag);
                                      controller.tagFieldController.clear();
                                    }
                                  },
                                ),
                              ),
                              controller: controller.tagFieldController,
                              // onSaved: (val) {},
                              // validator: (val) {},

                              // expands: false,
                            ),
                            SizedBox(height: 20),
                            Wrap(
                              spacing: 4,
                              children: List.generate(
                                controller.tags.length,
                                (index) => Chip(
                                  label: Text(
                                    controller.tags[index],
                                    style: TextStyle(
                                        color: Get.theme.primaryColor,
                                        fontSize: 13),
                                  ),
                                  deleteIcon: Icon(Icons.close,
                                      size: 16, color: Get.theme.primaryColor),
                                  onDeleted: () {
                                    controller.tags.removeAt(index);
                                  },
                                  backgroundColor: Colors.white,
                                  elevation: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: CustomPrimaryButton(
                                  text: "Post", onPressed: () {}),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              });
        });
  }
}

class _IngredientsAndInstructionsController extends GetxController {
  // RxList<Ing> ingredients = RxList();
  RxList<TextEditingController> ingredientsTextControllers = RxList();
  RxList<TextEditingController> ingredientsQuantityTextControllers = RxList();
  RxList<TextEditingController> instructionsTextControllers = RxList();
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
