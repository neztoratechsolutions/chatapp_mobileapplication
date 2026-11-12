import 'package:get/get.dart';
import 'creator_gallery_controller.dart';

class CreatorGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatorGalleryController>(() => CreatorGalleryController());
  }
}
