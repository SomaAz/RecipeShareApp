import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/home_view_controller.dart';
import 'package:recipes_sharing_app/core/service/firebase_auth_service.dart';
import 'package:recipes_sharing_app/core/service/firestore_service.dart';
import 'package:recipes_sharing_app/model/user_model.dart';
import 'package:recipes_sharing_app/view/screen/post_recipe_view.dart';

class AppDrawer extends GetWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: FirestoreService().getCurrentUserData(),
        builder: (_, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final userData = snapshot.data!;
          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Get.mediaQuery.size.width * .2,
                            height: Get.mediaQuery.size.width * .2,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(userData.imageUrl),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData.username,
                                style: const TextStyle(fontSize: 22),
                              ),
                              Text(
                                userData.email,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(height: 0),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.put(HomeViewController()).setSelectedScreenIndex(3);
                  },
                  title: Text(
                    "Account",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.person),
                ),
                Divider(height: 0),
                ListTile(
                  onTap: () {
                    Get.to(() => PostRecipeView());
                  },
                  title: Text(
                    "Post a New Recipe",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.add),
                ),
                Divider(height: 0),
                ListTile(
                  onTap: () async {
                    await FirebaseAuthService().logUserOut();
                  },
                  title: Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.logout_outlined),
                ),
                Divider(height: 0),
              ],
            ),
          );
        },
      ),
    );
  }
}
