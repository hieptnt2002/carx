import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt currentItem = 0.obs;
  void updateItem(int item) {
    currentItem.value = item;
  }
}
