import 'package:get/get.dart';

class SettingsController extends GetxController {
  final pushNotifications = true.obs;
  final onlineStatus = true.obs;
  final showInSearch = true.obs;
  final autoRechargeCoins = false.obs;

  void togglePushNotifications(bool val) => pushNotifications.value = val;
  void toggleOnlineStatus(bool val) => onlineStatus.value = val;
  void toggleShowInSearch(bool val) => showInSearch.value = val;
  void toggleAutoRechargeCoins(bool val) => autoRechargeCoins.value = val;
}
