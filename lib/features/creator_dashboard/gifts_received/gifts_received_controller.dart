import 'package:get/get.dart';

class GiftBreakdownItem {
  final String emoji;
  final int coins;
  final double heightFraction;

  GiftBreakdownItem({
    required this.emoji,
    required this.coins,
    required this.heightFraction,
  });
}

class GiftsReceivedController extends GetxController {
  // Selected tab: 'Dashboard', 'Profile Setup', 'KYC', 'Gallery', 'Pricing', 'Earnings', 'Gifts'
  final selectedTab = 'Gifts'.obs;

  // Status: Online / Offline
  final isOnline = true.obs;

  // 2x2 Metric values
  final totalGifts = 39.obs;
  final giftCoins = 2480.obs;
  final yourEarnings = 496.obs;
  final topSupporter = 'Vikram'.obs;

  // List of gift breakdown items matching mockup
  final List<GiftBreakdownItem> breakdownItems = [
    GiftBreakdownItem(emoji: '🌹', coins: 120, heightFraction: 0.25),
    GiftBreakdownItem(emoji: '💖', coins: 360, heightFraction: 0.70),
    GiftBreakdownItem(emoji: '🍫', coins: 0, heightFraction: 0.0),
    GiftBreakdownItem(emoji: '☕', coins: 0, heightFraction: 0.0),
    GiftBreakdownItem(emoji: '🧸', coins: 0, heightFraction: 0.0),
    GiftBreakdownItem(emoji: '🎂', coins: 400, heightFraction: 0.82),
    GiftBreakdownItem(emoji: '🧴', coins: 0, heightFraction: 0.0),
  ];

  // Tooltip display states (which index is showing tooltip)
  final showTooltipIndex = 5.obs; // Pre-select Cake (index 5) to match mockup screenshot tooltip display!

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
  }

  void selectBar(int index) {
    if (breakdownItems[index].coins > 0) {
      showTooltipIndex.value = index;
    } else {
      showTooltipIndex.value = -1; // hide if empty
    }
  }

  void changeTab(String tabName) {
    if (tabName == 'Dashboard') {
      Get.offNamed('/creator-dashboard');
    } else if (tabName == 'Profile Setup') {
      Get.offNamed('/profile-setup');
    } else if (tabName == 'KYC') {
      Get.offNamed('/kyc-verify');
    } else if (tabName == 'Gallery') {
      Get.offNamed('/creator-gallery');
    } else if (tabName == 'Pricing') {
      Get.offNamed('/creator-pricing');
    } else if (tabName == 'Earnings') {
      Get.offNamed('/creator-earnings');
    } else if (tabName == 'Inbox') {
      Get.offNamed('/inbox');
    } else {
      selectedTab.value = tabName;
    }
  }
}
