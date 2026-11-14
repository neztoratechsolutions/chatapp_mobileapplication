import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api_endpoints.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  final GetConnect _connect = GetConnect();

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();

    // 1. Email validation
    if (email.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final body = {'email': email};

      print('========================================');
      print('Forgot Password API Endpoint: ${ApiEndpoints.forgotPasswordUrl}');
      print('Forgot Password API Request Body: $body');

      final response = await _connect.post(ApiEndpoints.forgotPasswordUrl, body);

      print('Forgot Password API Response Status Code: ${response.statusCode}');
      print('Forgot Password API Response Body: ${response.body}');
      print('========================================');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        String message = 'OTP code sent to $email';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'].toString();
        }

        Get.snackbar(
          'Success',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate to OTP page
        Get.toNamed('/otp', arguments: {'email': email});
      } else {
        String errorMessage = 'Failed to send OTP code. Please try again.';
        if (response.body is Map) {
          final resMap = response.body as Map;
          if (resMap['detail'] != null) {
            errorMessage = resMap['detail'].toString();
          } else if (resMap['message'] != null) {
            errorMessage = resMap['message'].toString();
          } else if (resMap['error'] != null) {
            errorMessage = resMap['error'].toString();
          }
        } else if (response.statusText != null &&
            response.statusText!.isNotEmpty) {
          errorMessage = response.statusText!;
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Forgot Password API Exception: $e');
      print('========================================');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.offNamed('/login');
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
