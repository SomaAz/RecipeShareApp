import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/auth_controller.dart';
import 'package:recipes_sharing_app/view/screen/auth/login_view.dart';
import 'package:recipes_sharing_app/view/screen/auth/register_view.dart';
import 'package:recipes_sharing_app/view/widget/custom_buttons.dart';

class AuthView extends GetWidget<AuthController> {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Recipeshare",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),
                WhiteCustomButton(
                  text: "Login",
                  onPressed: () {
                    Get.to(() => LoginView());
                  },
                ),
                SizedBox(height: 20),
                WhiteCustomButton(
                  text: "Register",
                  onPressed: () {
                    Get.to(() => RegisterView());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, {required void Function() onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 8, vertical: 16)),
      ),
    );
  }
}
