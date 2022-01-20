import 'package:flutter/material.dart';
import 'package:recipes_sharing_app/core/service/firebase_auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            onTap: () {
              FirebaseAuthService().logUserOut();
            },
          )
        ],
      ),
    );
  }
}
