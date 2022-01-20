import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/auth_controller.dart';
import 'package:recipes_sharing_app/view/screen/auth/register_view.dart';
import 'package:recipes_sharing_app/view/widget/custom_buttons.dart';

class LoginView extends GetWidget<AuthController> {
  LoginView({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.showPassword.value;
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
                          // buildAppLogo(24),
                          // SizedBox(height: 30),
                          SizedBox(height: 0),
                          Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 25),

                          Image.asset(
                            "assets/images/logo.png",
                            scale: 4.2,
                          ),
                          SizedBox(height: 15),

                          // SizedBox(height: 25),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
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
                                  onSaved: (val) {
                                    if (val != null) {
                                      controller.setPassword(val.trim());
                                    }
                                  },
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Please enter this field";
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: !controller.showPassword.value,
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
                                  text: "Login",
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      controller.logUserin();
                                    }
                                  },
                                ),
                          SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              TextButton(
                                child: Text(
                                  "Create One",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Get.off(() => RegisterView());
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
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
