import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/services/session_service.dart';

class InboxController extends GetxController {
  // Selected tab: 'Dashboard', 'Profile Setup', 'KYC', 'Gallery', 'Pricing', 'Earnings', 'Gifts', 'Inbox'
  final selectedTab = 'Inbox'.obs;

  // Status: Online / Offline
  final isOnline = true.obs;
  final isUpdatingStatus = false.obs;
  final userId = 21.obs;

  final GetConnect _connect = GetConnect();

  // Mock conversation list matching the screenshot
  final conversations = <Map<String, dynamic>>[
    {
      'name': 'Priya Sharma',
      'avatar': 'https://picsum.photos/seed/priya-chat/200/200',
      'message': 'Hey! 👋',
      'time': 'now',
      'unread': 1,
      'online': true,
    },
    {
      'name': 'Ananya Kapoor',
      'avatar': 'https://picsum.photos/seed/ananya-chat/200/200',
      'message': 'Call me na',
      'time': '2m',
      'unread': 2,
      'online': true,
    },
    {
      'name': 'Riya Verma',
      'avatar': 'https://picsum.photos/seed/riya-chat/200/200',
      'message': 'haha 😂',
      'time': '10m',
      'unread': 0,
      'online': true,
    },
    {
      'name': 'Sneha Iyer',
      'avatar': 'https://picsum.photos/seed/sneha-chat/200/200',
      'message': 'Tomorrow?',
      'time': '1h',
      'unread': 0,
      'online': false,
    },
    {
      'name': 'Kavya Reddy',
      'avatar': 'https://picsum.photos/seed/kavya-chat/200/200',
      'message': 'Online?',
      'time': 'yesterday',
      'unread': 0,
      'online': false,
    },
    {
      'name': 'Aisha Khan',
      'avatar': 'https://picsum.photos/seed/aisha-chat/200/200',
      'message': 'Hey! 👋',
      'time': 'now',
      'unread': 0,
      'online': true,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _connect.timeout = const Duration(seconds: 15);
    _loadSession();
  }

  Future<void> _loadSession() async {
    final id = await SessionService.getUserId();
    if (id > 0) userId.value = id;
  }

  Future<void> toggleOnlineStatus() async {
    if (isUpdatingStatus.value) return;
    isUpdatingStatus.value = true;

    final targetStatus = !isOnline.value;

    try {
      if (userId.value <= 0) {
        userId.value = await SessionService.getUserId();
      }
      if (userId.value <= 0) {
        userId.value = 21;
      }

      final body = {
        'user_id': userId.value,
        'is_online': targetStatus,
      };

      final token = await SessionService.getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      Response response = await _connect.post(
        ApiEndpoints.userStatusUrl,
        body,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null && response.body is Map) {
          final resMap = response.body as Map;
          if (resMap['is_online'] != null) {
            isOnline.value = resMap['is_online'] == true;
          } else {
            isOnline.value = targetStatus;
          }
        } else {
          isOnline.value = targetStatus;
        }

        Get.snackbar(
          'Status Updated',
          isOnline.value ? 'You are now Online' : 'You are now Offline',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: isOnline.value ? const Color(0xFF0F3223) : const Color(0xFF221F35),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (_) {
      isOnline.value = targetStatus;
    } finally {
      isUpdatingStatus.value = false;
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
    } else if (tabName == 'Gifts') {
      Get.offNamed('/gifts-received');
    } else {
      selectedTab.value = tabName;
    }
  }
}
