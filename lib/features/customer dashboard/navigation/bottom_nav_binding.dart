import 'package:get/get.dart';
import 'bottom_nav_controller.dart';
import '../home/home_controller.dart';
import '../../creator_dashboard/creators/creators_controller.dart';
import '../chat/chat_controller.dart';
import '../game/game_controller.dart';
import '../profile/profile_controller.dart';
import '../favorites/favorites_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CreatorsController>(() => CreatorsController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<GameController>(() => GameController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}
