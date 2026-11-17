import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyEarning {
  final String day;
  final double value; // height percentage

  DailyEarning({required this.day, required this.value});
}

class CreatorEarningsController extends GetxController {
  // Selected tab: 'Dashboard', 'Profile Setup', 'KYC', 'Gallery', 'Pricing', 'Earnings', 'Gifts'
  final selectedTab = 'Earnings'.obs;

  // Status: Online / Offline
  final isOnline = true.obs;

  // Stats values
  final totalEarned = 12450.obs;
  final availablePayout = 4820.obs;

  // Last 7 days earnings representation
  final List<DailyEarning> dailyEarnings = [
    DailyEarning(day: 'Mon', value: 0.25),
    DailyEarning(day: 'Tue', value: 0.40),
    DailyEarning(day: 'Wed', value: 0.35),
    DailyEarning(day: 'Thu', value: 0.52),
    DailyEarning(day: 'Fri', value: 0.70),
    DailyEarning(day: 'Sat', value: 0.95),
    DailyEarning(day: 'Sun', value: 0.85),
  ];

  // Withdrawal state
  final isWithdrawing = false.obs;

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
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
    } else if (tabName == 'Gifts') {
      Get.offNamed('/gifts-received');
    } else if (tabName == 'Inbox') {
      Get.offNamed('/inbox');
    } else {
      selectedTab.value = tabName;
    }
  }

  // Withdraw simulation
  void withdrawPayout() {
    if (availablePayout.value <= 0) {
      Get.snackbar(
        'Unavailable',
        'No available payout to withdraw.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF17132F),
        colorText: Colors.white,
        icon: const Icon(Icons.info_outline, color: Colors.white70),
      );
      return;
    }

    isWithdrawing.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      final amount = availablePayout.value;
      availablePayout.value = 0;
      isWithdrawing.value = false;

      Get.snackbar(
        'Success',
        'Withdrawal request of ₹$amount submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F3223),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF00C853)),
      );
    });
  }
}
