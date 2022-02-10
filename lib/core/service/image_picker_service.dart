import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  Future<XFile?> _pickImage(ImageSource source) async {
    return (await ImagePicker().pickImage(source: source, imageQuality: 55));
  }

  Future<XFile?> pickImageFromGallery() async {
    return await _pickImage(ImageSource.gallery);
  }

  Future<XFile?> pickImageFromCamera() async {
    return await _pickImage(ImageSource.camera);
  }

  Future<List<XFile>?> pickMultipeImages() async {
    return await ImagePicker().pickMultiImage(imageQuality: 55);
  }

  void showImagePickerDialog(void Function(XFile? pickedImage) onPick) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(flex: 0, child: Text("Add a profile image")),
              Flexible(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final XFile? pickedImage = (await ImagePickerService()
                            .pickImageFromGallery()
                            .then(
                          (value) {
                            Get.back();
                            return value;
                          },
                        ));
                        print("${await pickedImage!.length() / 1024}KB");
                        onPick(pickedImage);
                      },
                      child: Text("From Gallery"),
                    ),
                    TextButton(
                      onPressed: () async {
                        onPick(
                          await ImagePickerService().pickImageFromCamera().then(
                            (value) {
                              Get.back();
                              return value;
                            },
                          ),
                        );
                      },
                      child: Text("From Camera"),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 0,
                child: TextButton(
                  onPressed: () async {
                    onPick(null);
                    Get.back();
                  },
                  child: Text("Remove Image"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
