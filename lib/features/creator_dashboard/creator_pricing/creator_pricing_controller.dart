import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatorPricingController extends GetxController {
  // Selected tab: 'Dashboard', 'Profile Setup', 'KYC', 'Gallery', 'Pricing'
  final selectedTab = 'Pricing'.obs;

  // Status: Online / Offline
  final isOnline = true.obs;

  // Pricing values (RxDouble)
  final chatRate = 12.0.obs;       // bounds: 2 - 30
  final voiceCallRate = 25.0.obs;  // bounds: 10 - 100
  final videoCallRate = 50.0.obs;  // bounds: 20 - 200

  // Save loading state
  final isSaving = false.obs;

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
  }

  void changeTab(String tabName) {
    if (tabName == 'Dashboard') {
      Get.back();
    } else if (tabName == 'Profile Setup') {
      Get.offNamed('/profile-setup');
    } else if (tabName == 'KYC') {
      Get.offNamed('/kyc-verify');
    } else if (tabName == 'Gallery') {
      Get.offNamed('/creator-gallery');
    } else if (tabName == 'Earnings') {
      Get.offNamed('/creator-earnings');
    } else if (tabName == 'Gifts') {
      Get.offNamed('/gifts-received');
    } else if (tabName == 'Inbox') {
      Get.offNamed('/inbox');
    } else {
      selectedTab.value = tabName;
    }
  }

  // Update rates
  void updateChatRate(double value) {
    chatRate.value = value.roundToDouble();
  }

  void updateVoiceCallRate(double value) {
    voiceCallRate.value = value.roundToDouble();
  }

  void updateVideoCallRate(double value) {
    videoCallRate.value = value.roundToDouble();
  }

  // Save pricing simulation
  void savePricing() {
    isSaving.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      isSaving.value = false;
      Get.snackbar(
        'Success',
        'Pricing updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F3223),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF00C853)),
      );
    });
  }
}
