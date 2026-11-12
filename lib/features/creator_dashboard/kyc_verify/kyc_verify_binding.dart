import 'package:get/get.dart';
import 'kyc_verify_controller.dart';

class KycVerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KycVerifyController>(() => KycVerifyController());
  }
}
