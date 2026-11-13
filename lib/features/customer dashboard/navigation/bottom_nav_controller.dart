import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final index = 0.obs;

  void changeTab(int i) => index.value = i;
}
