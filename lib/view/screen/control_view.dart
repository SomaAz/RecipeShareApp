import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/auth_controller.dart';
import 'package:recipes_sharing_app/view/screen/auth/auth_view.dart';
import 'package:recipes_sharing_app/view/screen/home_view.dart';

class ControlView extends GetWidget<AuthController> {
  const ControlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.user == null) {
        return AuthView();
      } else {
        return HomeView();
      }
    });
  }
}
