import 'package:get/get.dart';
import 'gifts_received_controller.dart';

class GiftsReceivedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GiftsReceivedController>(() => GiftsReceivedController());
  }
}
