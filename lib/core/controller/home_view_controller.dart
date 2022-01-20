import 'package:get/get.dart';

class HomeViewController extends GetxController {
  int _selectedScreenIndex = 0;
  int get selectedScreenIndex => _selectedScreenIndex;

  void setSelectedScreenIndex(int val) {
    _selectedScreenIndex = val;
    update();
  }
}
