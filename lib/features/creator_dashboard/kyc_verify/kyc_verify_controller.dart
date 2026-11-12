import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KycVerifyController extends GetxController {
  // Online/Offline status
  final isOnline = true.obs;

  // Selected tab: 'Dashboard', 'Profile Setup', 'KYC'
  final selectedTab = 'KYC'.obs;

  // Step Statuses
  final isVoiceCompleted = false.obs;
  final isSelfieCompleted = false.obs;
  final isBankCompleted = false.obs;

  // Voice Recording simulation states
  final isRecording = false.obs;
  final recordingSeconds = 5.obs;

  // Selfie Upload simulation state
  final isSelfieUploading = false.obs;

  // Bank details text controllers
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();
  final accountNumber = ''.obs;
  final ifsc = ''.obs;

  @override
  void onClose() {
    accountNumberController.dispose();
    ifscController.dispose();
    super.onClose();
  }

  // Get completed steps count
  int get completedStepsCount {
    int count = 0;
    if (isVoiceCompleted.value) count++;
    if (isSelfieCompleted.value) count++;
    if (isBankCompleted.value) count++;
    return count;
  }

  // Get progress fraction
  double get progressFraction => completedStepsCount / 3.0;

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
  }

  void changeTab(String tabName) {
    if (tabName == 'Dashboard') {
      Get.back();
    } else if (tabName == 'Profile Setup') {
      Get.offNamed('/profile-setup');
    } else if (tabName == 'Gallery') {
      Get.offNamed('/creator-gallery');
    } else if (tabName == 'Pricing') {
      Get.offNamed('/creator-pricing');
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

  // Start Voice Verification simulation
  void startVoiceRecording() {
    isRecording.value = true;
    recordingSeconds.value = 5;
    
    _runCountdown();
  }

  void _runCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!isRecording.value) return;
      
      recordingSeconds.value--;
      if (recordingSeconds.value <= 0) {
        isRecording.value = false;
        isVoiceCompleted.value = true;
        Get.snackbar(
          'Success',
          'Voice sample recorded successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0F3223),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Color(0xFF00C853)),
        );
      } else {
        _runCountdown();
      }
    });
  }

  // Start Selfie Verification simulation
  void startSelfieVerification() {
    isSelfieUploading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isSelfieUploading.value = false;
      isSelfieCompleted.value = true;
      Get.snackbar(
        'Success',
        'Selfie uploaded and verified!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F3223),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Color(0xFF00C853)),
      );
    });
  }

  // Save bank details
  void saveBankDetails() {
    final accNo = accountNumberController.text.trim();
    final ifscVal = ifscController.text.trim();

    if (accNo.isEmpty || ifscVal.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both Account Number and IFSC Code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF17132F),
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.redAccent),
      );
      return;
    }

    accountNumber.value = accNo;
    ifsc.value = ifscVal;
    isBankCompleted.value = true;
    
    Get.snackbar(
      'Success',
      'Bank details saved successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F3223),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Color(0xFF00C853)),
    );
  }
}
