import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api_endpoints.dart';

class OtpController extends GetxController {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final email = ''.obs;
  final pin = ''.obs;
  final int pinLength = 6;

  final isLoading = false.obs;
  final isResending = false.obs;
  final resendCountdown = 30.obs;
  Timer? _timer;

  final GetConnect _connect = GetConnect();

  @override
  void onInit() {
    super.onInit();
    _connect.timeout = const Duration(seconds: 15);
    if (Get.arguments != null) {
      if (Get.arguments is Map && Get.arguments['email'] != null) {
        email.value = Get.arguments['email'].toString().trim();
      } else if (Get.arguments is String) {
        email.value = Get.arguments.toString().trim();
      }
    }
    // Fallback if tested directly in VS Code
    if (email.value.isEmpty) {
      email.value = 'asiva1317@gmail.com';
    }
    startResendTimer();
  }

  void startResendTimer() {
    _timer?.cancel();
    resendCountdown.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void onPinChanged(String value) {
    pin.value = value;
  }

  void showChangeEmailDialog() {
    final tempController = TextEditingController(text: email.value);
    Get.defaultDialog(
      title: 'Update Email',
      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      backgroundColor: const Color(0xFF1E1538),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: tempController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: const Color(0x1AFFFFFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      textConfirm: 'Save',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEF3AAB),
      onConfirm: () {
        final newEmail = tempController.text.trim();
        if (newEmail.isNotEmpty && GetUtils.isEmail(newEmail)) {
          email.value = newEmail;
          Get.back();
        } else {
          Get.snackbar(
            'Error',
            'Please enter a valid email address',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
      textCancel: 'Cancel',
      cancelTextColor: Colors.white70,
    );
  }

  Future<void> verifyOtp() async {
    final enteredPin = pin.value.trim().isNotEmpty
        ? pin.value.trim()
        : pinController.text.trim();
    final currentEmail = email.value.trim();

    if (currentEmail.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Email address is missing. Please enter your email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (enteredPin.length < pinLength) {
      Get.snackbar(
        'Validation Error',
        'Please enter the complete $pinLength-digit OTP',
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
        'email': currentEmail,
        'otp': enteredPin,
      };

      print('========================================');
      print('Verify OTP API Endpoint: ${ApiEndpoints.verifyOtpUrl}');
      print('Verify OTP API Request Body: $body');

      Response response = await _connect.post(
        ApiEndpoints.verifyOtpUrl,
        body,
        headers: headers,
      );

      print('Verify OTP API Response Status Code: ${response.statusCode}');
      print('Verify OTP API Response Body: ${response.body}');

      // Fallback 1: if 404, 301, 307, 405, retry with trailing slash
      if (response.statusCode == 404 ||
          response.statusCode == 301 ||
          response.statusCode == 307 ||
          response.statusCode == 405) {
        final trailingUrl = '${ApiEndpoints.verifyOtpUrl}/';
        print('Retrying with trailing slash: $trailingUrl...');
        final retrySlash = await _connect.post(
          trailingUrl,
          body,
          headers: headers,
        );
        print('Trailing Slash Status Code: ${retrySlash.statusCode}');
        print('Trailing Slash Body: ${retrySlash.body}');
        if (retrySlash.statusCode == 200 || retrySlash.statusCode == 201) {
          response = retrySlash;
        }
      }

      // Fallback 2: if 422 or 400, retry with integer OTP
      if ((response.statusCode == 422 || response.statusCode == 400) &&
          int.tryParse(enteredPin) != null) {
        print('Retrying with integer otp payload...');
        final retryInt = await _connect.post(
          ApiEndpoints.verifyOtpUrl,
          {
            'email': currentEmail,
            'otp': int.parse(enteredPin),
          },
          headers: headers,
        );
        print('Integer Retry Status Code: ${retryInt.statusCode}');
        print('Integer Retry Body: ${retryInt.body}');
        if (retryInt.statusCode == 200 || retryInt.statusCode == 201) {
          response = retryInt;
        }
      }

      // Fallback 3: if 422 or 400, retry with 'code' key
      if (response.statusCode == 422 || response.statusCode == 400) {
        print('Retrying with alternative payload {email, code}...');
        final retryCode = await _connect.post(
          ApiEndpoints.verifyOtpUrl,
          {
            'email': currentEmail,
            'code': enteredPin,
          },
          headers: headers,
        );
        print('Code Retry Status Code: ${retryCode.statusCode}');
        print('Code Retry Body: ${retryCode.body}');
        if (retryCode.statusCode == 200 || retryCode.statusCode == 201) {
          response = retryCode;
        }
      }

      print('========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        String message = 'OTP verified successfully';
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

        // Navigate to Reset Password Page
        Get.offNamed('/reset-password', arguments: {
          'email': currentEmail,
          'otp': enteredPin,
        });
      } else {
        String errorMessage = 'Invalid OTP code. Please try again.';
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
          'Verification Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Verify OTP API Exception: $e');
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

  Future<void> resendOtp() async {
    if (resendCountdown.value > 0) return;

    isResending.value = true;
    try {
      final currentEmail = email.value.trim();
      final body = {'email': currentEmail};

      print('========================================');
      print('Resend OTP API Endpoint: ${ApiEndpoints.forgotPasswordUrl}');
      print('Resend OTP API Request Body: $body');

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final response = await _connect.post(
        ApiEndpoints.forgotPasswordUrl,
        body,
        headers: headers,
      );

      print('Resend OTP API Response Status Code: ${response.statusCode}');
      print('Resend OTP API Response Body: ${response.body}');
      print('========================================');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        pinController.clear();
        pin.value = '';
        startResendTimer();

        Get.snackbar(
          'Success',
          'A new OTP code has been sent to $currentEmail',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String msg = 'Failed to resend OTP. Please try again.';
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
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isResending.value = false;
    }
  }

  void goToLogin() {
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    _timer?.cancel();
    pinController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
