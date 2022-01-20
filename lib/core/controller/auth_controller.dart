import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes_sharing_app/core/service/firebase_auth_service.dart';
import 'package:recipes_sharing_app/core/service/firebase_storage_service.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/user_model.dart';

class AuthController extends GetxController {
  // ignore: prefer_final_fields
  Rx<User?> _user = Rx(null);
  User? get user => _user.value;
  String _username = "", _password = "", _email = "";
  Rx<XFile?> image = Rx(null);
  Rx<bool> isLoading = Rx(false);
  Rx<bool> showPassword = Rx(false);
  Rx<bool> showConfirmPassword = Rx(false);
  @override
  void onInit() {
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    super.onInit();
  }

  Future<void> registerUser() async {
    isLoading.value = true;

    await FirebaseAuthService().registerUser(_email, _password, _username).then(
      (credential) async {
        if (image == null) {
          await FirestoreService()
              .addUserToFirestore(
            UserModel(
              uid: credential.user!.uid,
              username: _username,
              email: _email,
              imageUrl: "",
            ),
          )
              .then((value) {
            isLoading.value = false;
            if (user != null) {
              Get.back();
            }
          });
        } else {
          await FirebaseStorageService()
              .uploadImageToStorage(
                  File(image.value!.path), "${credential.user!.uid}.image")
              .then(
            (imageUrl) async {
              await FirestoreService()
                  .addUserToFirestore(
                UserModel(
                  uid: credential.user!.uid,
                  username: _username,
                  email: _email,
                  imageUrl: imageUrl,
                ),
              )
                  .then((value) {
                isLoading.value = false;
                if (user != null) {
                  Get.back();
                }
              }).onError((error, stackTrace) {
                isLoading.value = false;
              });
            },
          ).onError((error, stackTrace) {
            isLoading.value = false;
          });
        }
      },
    ).onError((error, stackTrace) {
      isLoading.value = false;
    });

    // setIsLoading(false);
  }

  Future<void> logUserin() async {
    isLoading.value = true;

    await FirebaseAuthService().logUserIn(_email, _password).then((value) {
      isLoading.value = false;
      if (user != null) {
        Get.back();
      }
    }).onError((error, stackTrace) {
      isLoading.value = false;
    });
  }

  Future<void> logUserOut() async {
    FirebaseAuthService().logUserOut();
  }

  void setUsername(String value) {
    _username = value;
  }

  void setEmail(String value) {
    _email = value;
  }

  void setPassword(String value) {
    _password = value;
  }

  void setImage(XFile? file) {
    print(user);
    image.value = file;
  }
}
