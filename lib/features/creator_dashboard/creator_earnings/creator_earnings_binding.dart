import 'package:get/get.dart';
import 'creator_earnings_controller.dart';

class CreatorEarningsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatorEarningsController>(() => CreatorEarningsController());
  }
}
