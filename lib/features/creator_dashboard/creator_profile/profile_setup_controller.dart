import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSetupController extends GetxController {
  // Text controllers
  final displayNameController = TextEditingController(text: 'Riya Creator');
  final bioController = TextEditingController(text: "Let's vibe! Music, movies & midnight chats 🌙");

  // Observable values
  final displayName = 'Riya Creator'.obs;
  final bio = "Let's vibe! Music, movies & midnight chats 🌙".obs;
  final selectedImagePath = ''.obs;
  File? selectedImage;

  // Online status
  final isOnline = true.obs;

  // Selected tab: 'Profile Setup', 'Dashboard', 'KYC'
  final selectedTab = 'Profile Setup'.obs;



  @override
  void onClose() {
    displayNameController.dispose();
    bioController.dispose();
    super.onClose();
  }

  void onDisplayNameChanged(String value) {
    displayName.value = value;
  }

  void onBioChanged(String value) {
    bio.value = value;
  }

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
  }

  void changeTab(String tabName) {
    if (tabName == 'Dashboard') {
      Get.back();
    } else if (tabName == 'KYC') {
      Get.offNamed('/kyc-verify');
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

  void pickImage() {
    // TODO: Implement image picker
    // For now, show a snackbar
    Get.snackbar(
      'Photo Upload',
      'Image picker will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF17132F),
      colorText: Colors.white,
    );
  }

  void saveProfile() {
    if (displayName.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a display name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF17132F),
        colorText: Colors.white,
      );
      return;
    }

    // Save profile data
    // TODO: Implement actual save logic (API call, local storage, etc.)

    Get.snackbar(
      'Success',
      'Profile saved successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F3223),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Color(0xFF00C853)),
    );

    // Navigate back to dashboard
    Get.back();
  }
}
