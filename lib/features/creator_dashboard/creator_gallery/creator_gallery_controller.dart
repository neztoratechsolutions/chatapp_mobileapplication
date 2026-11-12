import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryItem {
  final String id;
  final List<Color> colors;

  GalleryItem({required this.id, required this.colors});
}

class CreatorGalleryController extends GetxController {
  // Selected tab: 'Dashboard', 'Profile Setup', 'KYC', 'Gallery', 'Pricing'
  final selectedTab = 'Gallery'.obs;

  // Status: Online / Offline
  final isOnline = true.obs;

  // List of uploaded photos (up to 8)
  final images = <GalleryItem>[
    GalleryItem(
      id: '1',
      colors: [const Color(0xFFFF58D6), const Color(0xFF8D32F0)],
    ),
    GalleryItem(
      id: '2',
      colors: [const Color(0xFF8D32F0), const Color(0xFF3F51B5)],
    ),
    GalleryItem(
      id: '3',
      colors: [const Color(0xFF00C8FF), const Color(0xFF8D32F0)],
    ),
    GalleryItem(
      id: '4',
      colors: [const Color(0xFF3F51B5), const Color(0xFFFF58D6)],
    ),
  ].obs;

  // Uploading state
  final isUploading = false.obs;

  // Preset premium gradients to pick from randomly during simulation
  final List<List<Color>> _presetGradients = [
    [const Color(0xFF00FFCC), const Color(0xFF0099FF)],
    [const Color(0xFFFF9900), const Color(0xFFFF007F)],
    [const Color(0xFF7F00FF), const Color(0xFFFF007F)],
    [const Color(0xFF00F2FE), const Color(0xFF4FACFE)],
    [const Color(0xFFFF3366), const Color(0xFFFF9933)],
  ];

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

  // Simulate picking/uploading an image
  void uploadImage() {
    if (images.length >= 8) {
      Get.snackbar(
        'Limit Reached',
        'You can upload up to 8 photos only.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF17132F),
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
      );
      return;
    }

    isUploading.value = true;

    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      final nextGradient = _presetGradients[images.length % _presetGradients.length];
      images.add(
        GalleryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          colors: nextGradient,
        ),
      );
      isUploading.value = false;

      Get.snackbar(
        'Success',
        'Photo uploaded successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F3223),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF00C853)),
      );
    });
  }

  // Delete an image
  void deleteImage(String id) {
    images.removeWhere((item) => item.id == id);
    Get.snackbar(
      'Removed',
      'Photo deleted from gallery.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF17132F),
      colorText: Colors.white,
      icon: const Icon(Icons.delete_outline, color: Colors.white70),
    );
  }
}
