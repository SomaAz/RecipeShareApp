import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/service/firebase_auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.mediaQuery.size.width * .2,
                        height: Get.mediaQuery.size.width * .2,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/images/logo.png"),
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Somaaz",
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            "hello@gmail.com",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(height: 24),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
