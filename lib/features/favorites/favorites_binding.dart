import 'package:get/get.dart';
import 'favorites_controller.dart';
import '../wallet/wallet_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    if (!Get.isRegistered<WalletController>()) {
      Get.lazyPut<WalletController>(() => WalletController());
    }
  }
}
