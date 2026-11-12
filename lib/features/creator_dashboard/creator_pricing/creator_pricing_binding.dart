import 'package:get/get.dart';
import 'creator_pricing_controller.dart';

class CreatorPricingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatorPricingController>(() => CreatorPricingController());
  }
}
