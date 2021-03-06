import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/home_view_controller.dart';
import 'package:recipes_sharing_app/core/service/firebase_auth_service.dart';
import 'package:recipes_sharing_app/view/screen/discover_view.dart';
import 'package:recipes_sharing_app/view/screen/favorite_view.dart';
import 'package:recipes_sharing_app/view/screen/my_profile_view.dart';
import 'package:recipes_sharing_app/view/screen/profile_view.dart';
import 'package:recipes_sharing_app/view/screen/saved_view.dart';

class HomeView extends GetWidget<HomeViewController> {
  const HomeView({Key? key}) : super(key: key);
  static const List<Widget> _screens = [
    DiscoverView(),
    SavedView(),
    FavoriteView(),
    MyProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuthService().getCurrentUserUid());
    return GetBuilder<HomeViewController>(
      builder: (controller) {
        return Scaffold(
          body: _screens[controller.selectedScreenIndex],
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 27,
            unselectedItemColor: Colors.black87,
            currentIndex: controller.selectedScreenIndex,
            onTap: (val) => controller.setSelectedScreenIndex(val),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline_outlined),
                activeIcon: Icon(
                  Icons.bookmark,
                  color: Colors.green,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline_outlined),
                activeIcon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_outlined),
                activeIcon: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                label: "",
              ),
            ],
          ),
        );
      },
    );
  }
  // CustomScrollView(
  //     slivers: [
  //       SliverAppBar(
  //         title: Text("Discover Recipes"),
  //       )
  //     ],
  //   )
}
