import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/service/image_picker_service.dart';

class PostViewController extends GetxController {
  RxList<File> images = RxList();
  Rx<String> name = Rx("");
  Rx<String> category = Rx("");
  Rx<int> cookTime = Rx(1);
  RxList<String> tags = RxList();
  final tagFieldController = TextEditingController();
  Future<void> getMuiltipeImages() async {
    var pickedImages = (await ImagePickerService().pickMultipeImages());
    //  && images.length + pickedImages.length <= 8
    if (pickedImages != null) {
      if (images.length + pickedImages.length > 8) {
        //images length = 5
        //pickedimages length = 4
        //pickedimages length should be 3 wich equls 8 - 5(images length)
        pickedImages = pickedImages.sublist(0, 8 - images.length);
      }
      images.addAll(pickedImages.map((xfile) => File(xfile.path)));
      print(images);
      print(images.length);
    }
    // .toList();
  }
}
