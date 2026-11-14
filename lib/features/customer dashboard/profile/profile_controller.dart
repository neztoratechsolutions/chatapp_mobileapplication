import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api_endpoints.dart';

class ProfileController extends GetxController {
  final name = 'Aarav User'.obs;
  final email = 'd@gmail.com'.obs;
  final phone = '+91 98765 43210'.obs;
  final location = 'Maharashtra'.obs;

  final isLoggingOut = false.obs;
  final GetConnect _connect = GetConnect();

  final profileMenu = <Map<String, dynamic>>[
    {'title': 'Edit Profile', 'icon': Icons.edit},
    {'title': 'Wallet', 'icon': Icons.account_balance_wallet_outlined},
    {'title': 'My Gifts Sent', 'icon': Icons.card_giftcard_outlined},
    {'title': 'Favorite Creators', 'icon': Icons.favorite_border},
    {'title': 'Rewards & Check-in', 'icon': Icons.emoji_events_outlined},
    {'title': 'Notifications', 'icon': Icons.notifications_none},
    {'title': 'Games', 'icon': Icons.videogame_asset_outlined},
    {'title': 'Settings', 'icon': Icons.settings_outlined},
    {'title': 'Logout', 'icon': Icons.logout, 'isLogout': true},
  ].obs;

  void confirmLogout() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1B1632),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout, color: Colors.redAccent, size: 30),
              ),
              const SizedBox(height: 18),
              const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Log Out',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    isLoggingOut.value = true;
    _connect.timeout = const Duration(seconds: 15);

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      print('========================================');
      print('Logout API Endpoint: ${ApiEndpoints.logoutUrl}');

      // Try POST first
      Response response = await _connect.post(
        ApiEndpoints.logoutUrl,
        {},
        headers: headers,
      );

      print('Logout API Response Status Code: ${response.statusCode}');
      print('Logout API Response Body: ${response.body}');

      // If method not allowed (405), fallback to GET
      if (response.statusCode == 405) {
        print('Retrying logout with GET method...');
        response = await _connect.get(
          ApiEndpoints.logoutUrl,
          headers: headers,
        );
        print('GET Logout Status Code: ${response.statusCode}');
        print('GET Logout Body: ${response.body}');
      }

      // If 404, 301, 307, try trailing slash
      if (response.statusCode == 404 || response.statusCode == 301 || response.statusCode == 307) {
        final trailingUrl = '${ApiEndpoints.logoutUrl}/';
        print('Retrying logout with trailing slash: $trailingUrl...');
        final retrySlash = await _connect.post(
          trailingUrl,
          {},
          headers: headers,
        );
        if (retrySlash.statusCode == 200 || retrySlash.statusCode == 201) {
          response = retrySlash;
        }
      }

      print('========================================');

      String message = 'Logout successful';
      if (response.body is Map && response.body['message'] != null) {
        message = response.body['message'].toString();
      }

      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 400));

      // Navigate back to Login and clear routes
      Get.offAllNamed('/login');
    } catch (e) {
      print('Logout Exception: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      Get.offAllNamed('/login');
    } finally {
      isLoggingOut.value = false;
    }
  }
}
