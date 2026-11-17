import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/services/session_service.dart';

class CreatorDashboardController extends GetxController {
  // Selected tab: 'Dashboard', 'Inbox', 'Reviews'
  final selectedTab = 'Dashboard'.obs;

  // Status: Online / Offline
  final isOnline = true.obs;
  final isUpdatingStatus = false.obs;
  final userId = 0.obs;

  final GetConnect _connect = GetConnect();

  // Mock creator details
  final creatorName = 'Riya'.obs;

  // Statistics data
  final todayEarnings = '₹1,840'.obs;
  final followersCount = '2,341'.obs;
  final callsCount = '23'.obs;
  final ratingValue = '4.8'.obs;
  final weeklyEarnings = '₹12,450'.obs;

  // Mock reviews list
  final reviews = <Map<String, dynamic>>[
    {
      'name': 'Aarav',
      'time': '2d',
      'rating': 5,
      'comment': 'Such a fun chat! 💯',
    },
    {
      'name': 'Rohan',
      'time': '5d',
      'rating': 4,
      'comment': 'Loved the energy, will call again.',
    },
    {
      'name': 'Karan',
      'time': '1w',
      'rating': 5,
      'comment': 'Amazing host, very kind.',
    },
  ].obs;

  // Mock conversations list for Inbox tab
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
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['user_id'] != null) {
        userId.value = int.tryParse(args['user_id'].toString()) ?? 0;
      } else if (args['id'] != null) {
        userId.value = int.tryParse(args['id'].toString()) ?? 0;
      }
      if (args['is_online'] != null) {
        isOnline.value = args['is_online'] == true;
      }
    }

    if (userId.value <= 0) {
      final savedId = await SessionService.getUserId();
      userId.value = savedId > 0 ? savedId : 21;
    }
    print('Creator Dashboard loaded with User ID: ${userId.value}');
  }

  Future<void> toggleOnlineStatus() async {
    if (isUpdatingStatus.value) return;
    isUpdatingStatus.value = true;

    if (userId.value <= 0) {
      userId.value = await SessionService.getUserId();
    }
    if (userId.value <= 0) {
      userId.value = 21; // Guaranteed fallback matching backend creator user id
    }

    final targetStatus = !isOnline.value;

    try {
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

      print('========================================');
      print('User Status API Endpoint: ${ApiEndpoints.userStatusUrl}');
      print('User Status API Request Body: $body');

      Response response = await _connect.post(
        ApiEndpoints.userStatusUrl,
        body,
        headers: headers,
      );
      print('User Status API Response Status Code: ${response.statusCode}');
      print('User Status API Response Body: ${response.body}');

      // Fallback: without trailing slash if 404, 301, or 307
      if (response.statusCode == 404 ||
          response.statusCode == 301 ||
          response.statusCode == 307) {
        final noSlashUrl = ApiEndpoints.userStatusUrl.endsWith('/')
            ? ApiEndpoints.userStatusUrl.substring(0, ApiEndpoints.userStatusUrl.length - 1)
            : ApiEndpoints.userStatusUrl;
        print('Retrying user status without trailing slash: $noSlashUrl...');
        final retryResponse = await _connect.post(noSlashUrl, body, headers: headers);
        if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
          response = retryResponse;
        }
      }

      print('========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null && response.body is Map) {
          final resMap = response.body as Map;
          if (resMap['is_online'] != null) {
            isOnline.value = resMap['is_online'] == true;
          } else {
            isOnline.value = targetStatus;
          }
          if (resMap['user_id'] != null) {
            userId.value = int.tryParse(resMap['user_id'].toString()) ?? userId.value;
          }
        } else {
          isOnline.value = targetStatus;
        }

        Get.snackbar(
          'Status Updated',
          isOnline.value
              ? 'You are now Online and available for calls'
              : 'You are now Offline',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor:
              isOnline.value ? const Color(0xFF0F3223) : const Color(0xFF221F35),
          colorText: Colors.white,
          icon: Icon(
            Icons.power_settings_new_rounded,
            color: isOnline.value ? const Color(0xFF00C853) : Colors.white54,
          ),
          duration: const Duration(seconds: 2),
        );
      } else {
        String msg = 'Failed to update status. Please try again.';
        if (response.body is Map && response.body['detail'] != null) {
          msg = response.body['detail'].toString();
        } else if (response.body is Map && response.body['message'] != null) {
          msg = response.body['message'].toString();
        }
        Get.snackbar(
          'Error',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('User Status Exception: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  void changeTab(String tabName) {
    if (tabName == 'Dashboard') {
      selectedTab.value = 'Dashboard';
    } else if (tabName == 'Inbox') {
      selectedTab.value = 'Inbox';
    } else if (tabName == 'Reviews') {
      selectedTab.value = 'Reviews';
    } else if (tabName == 'Profile Setup') {
      Get.toNamed('/profile-setup');
    } else if (tabName == 'KYC') {
      Get.toNamed('/kyc-verify');
    } else if (tabName == 'Gallery' || tabName == 'My Gallery') {
      Get.toNamed('/creator-gallery');
    } else if (tabName == 'Pricing') {
      Get.toNamed('/creator-pricing');
    } else if (tabName == 'Earnings') {
      Get.toNamed('/creator-earnings');
    } else if (tabName == 'Gifts') {
      Get.toNamed('/gifts-received');
    } else if (tabName == 'Logout') {
      confirmLogout();
    } else {
      selectedTab.value = tabName;
    }
  }

  void navigateToTool(String routeName) {
    Get.toNamed(routeName);
  }

  void confirmLogout() {
    Get.defaultDialog(
      title: 'Logout',
      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      middleText: 'Are you sure you want to logout?',
      middleTextStyle: const TextStyle(color: Colors.white70),
      backgroundColor: const Color(0xFF17132F),
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.white70,
      buttonColor: const Color(0xFFFF58D6),
      onConfirm: () {
        Get.back();
        logout();
      },
    );
  }

  Future<void> logout() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      await _connect.post(ApiEndpoints.logoutUrl, {}, headers: headers);
    } catch (_) {}
    await SessionService.clearSession();
    Get.offAllNamed('/login');
  }
}
