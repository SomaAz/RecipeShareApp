import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/auth_controller.dart';
import 'package:recipes_sharing_app/core/service/image_picker_service.dart';
import 'package:recipes_sharing_app/view/screen/auth/login_view.dart';
import 'package:recipes_sharing_app/view/widget/custom_buttons.dart';

class RegisterView extends GetWidget<AuthController> {
  RegisterView({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.showPassword.value;
      controller.showConfirmPassword.value;
      controller.image.value;
      controller.isLoading.value;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              ImagePickerService()
                                  .showImagePickerDialog((pickedImage) {
                                controller.setImage(pickedImage);
                                print(controller.image);
                              });
                            },
                            child: controller.image.value == null
                                ? Container(
                                    width: Get.mediaQuery.size.width * .38,
                                    height: Get.mediaQuery.size.width * .38,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Get.theme.primaryColor,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Add Profile Image",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ))
                                : SizedBox(
                                    width: Get.mediaQuery.size.width * .38,
                                    height: Get.mediaQuery.size.width * .38,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        Get.mediaQuery.size.width,
                                      ),
                                      child: Image.file(
                                        File(controller.image.value!.path),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                buildTextFormField(
                                    text: "UserName",
                                    icon: Icon(Icons.person),
                                    onSaved: (val) {
                                      if (val != null) {
                                        controller.setUsername(val.trim());
                                      }
                                    },
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Please enter this field";
                                      }
                                      if (val.trim().length < 5 ||
                                          val.trim().length > 24) {
                                        return "Username length starts from 5 up to 24 characters";
                                      }
                                      if (val.trim().contains(" ")) {
                                        return "You can't put spaces in your name";
                                      }
                                    },
                                    keyboardType: TextInputType.name),
                                SizedBox(height: 20),
                                buildTextFormField(
                                  text: "Email",
                                  icon: Icon(Icons.email),
                                  onSaved: (val) {
                                    if (val != null) {
                                      controller.setEmail(val.trim());
                                    }
                                  },
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please enter this field";
                                    }
                                    if (!val.trim().contains("@") ||
                                        val.trim().contains(" ")) {
                                      return "Please write the email correctly";
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 20),
                                buildTextFormField(
                                  text: "Password",
                                  icon: IconButton(
                                    icon: Icon(
                                      controller.showPassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      controller.showPassword.value =
                                          !controller.showPassword.value;
                                    },
                                  ),
                                  controller: _passwordController,
                                  onSaved: (val) {
                                    if (val != null) {
                                      controller.setPassword(val.trim());
                                    }
                                  },
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please enter this field";
                                    }
                                    if (val.trim().length < 8 ||
                                        val.trim().length > 26) {
                                      return "Password length starts from 8 up to 26 characters";
                                    }
                                    if (val.trim().contains(" ")) {
                                      return "You can't put spaces in your password";
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: !controller.showPassword.value,
                                ),
                                SizedBox(height: 20),
                                buildTextFormField(
                                  text: "Confirm Password",
                                  icon: IconButton(
                                    icon: Icon(
                                      controller.showConfirmPassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      controller.showConfirmPassword.value =
                                          !controller.showConfirmPassword.value;
                                    },
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please confirm the password";
                                    }
                                    if (val.trim() !=
                                        _passwordController.text.trim()) {
                                      return "Please confirm the password correctly";
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText:
                                      !controller.showConfirmPassword.value,
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          controller.isLoading.value
                              ? Center(child: CircularProgressIndicator())
                              : CustomPrimaryButton(
                                  text: "Register",
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      controller.registerUser();
                                    }
                                  },
                                ),
                          SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Or you have an account?"),
                              TextButton(
                                child: Text(
                                  "Login",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Get.off(() => LoginView());
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget buildTextFormField({
    required String text,
    Widget? icon,
    void Function(String?)? onSaved,
    String? Function(String?)? validator,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: text,
        // hintText: text,
        suffixIcon: icon,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
