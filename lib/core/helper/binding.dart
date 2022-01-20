import 'package:get/get.dart';
import 'package:recipes_sharing_app/core/controller/auth_controller.dart';
import 'package:recipes_sharing_app/core/controller/discover_view_controller.dart';
import 'package:recipes_sharing_app/core/controller/favorite_view_controller.dart';
import 'package:recipes_sharing_app/core/controller/home_view_controller.dart';
import 'package:recipes_sharing_app/core/controller/saved_view_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => HomeViewController());
    Get.lazyPut(() => DiscoverViewController());
    Get.lazyPut(() => SavedViewController());
    Get.lazyPut(() => FavoriteViewController());
  }
}
