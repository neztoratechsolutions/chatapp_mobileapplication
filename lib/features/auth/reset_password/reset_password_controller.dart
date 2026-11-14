import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api_endpoints.dart';

class ResetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;
  final otp = ''.obs;

  final GetConnect _connect = GetConnect();

  @override
  void onInit() {
    super.onInit();
    _connect.timeout = const Duration(seconds: 15);
    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['email'] != null) {
        emailController.text = Get.arguments['email'].toString().trim();
      }
      if (Get.arguments['otp'] != null) {
        otp.value = Get.arguments['otp'].toString().trim();
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // 1. Validation
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

    if (password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a new password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Validation Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (confirmPassword.isNotEmpty && password != confirmPassword) {
      Get.snackbar(
        'Validation Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final body = {
        'email': email,
        'password': password,
      };

      if (otp.value.isNotEmpty) {
        body['otp'] = otp.value;
      }

      print('========================================');
      print('Reset Password API Endpoint: ${ApiEndpoints.resetPasswordUrl}');
      print('Reset Password API Request Body: {email: $email, password: [PROTECTED], otp: ${otp.value}}');

      Response response = await _connect.post(
        ApiEndpoints.resetPasswordUrl,
        body,
        headers: headers,
      );

      print('Reset Password API Response Status Code: ${response.statusCode}');
      print('Reset Password API Response Body: ${response.body}');

      // Fallback 1: if 404, 301, 307, try trailing slash
      if (response.statusCode == 404 ||
          response.statusCode == 301 ||
          response.statusCode == 307) {
        final trailingUrl = '${ApiEndpoints.resetPasswordUrl}/';
        print('Retrying reset password with trailing slash: $trailingUrl...');
        final retrySlash = await _connect.post(
          trailingUrl,
          body,
          headers: headers,
        );
        if (retrySlash.statusCode == 200 || retrySlash.statusCode == 201) {
          response = retrySlash;
        }
      }

      // Fallback 2: if 422, try with 'new_password'
      if (response.statusCode == 422) {
        print('Retrying reset password with {email, new_password, otp}...');
        final retryBody = {
          'email': email,
          'new_password': password,
        };
        if (otp.value.isNotEmpty) {
          retryBody['otp'] = otp.value;
        }
        final retryResponse = await _connect.post(
          ApiEndpoints.resetPasswordUrl,
          retryBody,
          headers: headers,
        );
        print('Retry Status Code: ${retryResponse.statusCode}');
        print('Retry Body: ${retryResponse.body}');
        if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
          response = retryResponse;
        }
      }

      print('========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        String message = 'Password reset successfully! Please sign in.';
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

        await Future.delayed(const Duration(milliseconds: 600));

        // Go to Login
        Get.offAllNamed('/login');
      } else {
        String errorMessage = 'Password reset failed. Please try again.';
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
      print('Reset Password API Exception: $e');
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
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
