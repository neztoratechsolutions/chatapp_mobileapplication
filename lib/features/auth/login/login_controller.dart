import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/base_url.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  final GetConnect _connect = GetConnect();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    final rawEmail = emailController.text.trim();
    final password = passwordController.text;

    // 1. Validation
    if (rawEmail.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(rawEmail)) {
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
        'Please enter your password',
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

    isLoading.value = true;

    try {
      print('========================================');
      print('Login API Endpoint: ${ApiEndpoints.loginUrl}');
      print('Login API Request Body: {email: $rawEmail, password: [PROTECTED]}');

      Response response = await _connect.post(ApiEndpoints.loginUrl, {
        'email': rawEmail,
        'password': password,
      });

      print('Login API Response Status Code: ${response.statusCode}');
      print('Login API Response Body: ${response.body}');

      // If User not found (404), execute smart fallbacks:
      if (response.statusCode == 404) {
        // Fallback 1: Try with 'role': 'creator' in case backend filters by role
        print('Attempting fallback 1: With role="creator"...');
        final retryRole = await _connect.post(ApiEndpoints.loginUrl, {
          'email': rawEmail,
          'password': password,
          'role': 'creator',
        });
        print('Fallback 1 Status Code: ${retryRole.statusCode}');
        print('Fallback 1 Body: ${retryRole.body}');
        if (retryRole.statusCode == 200 || retryRole.statusCode == 201) {
          response = retryRole;
        }

        // Fallback 2: Check for domain typo like @gmai.com -> @gmail.com
        if (response.statusCode == 404 && rawEmail.contains('@gmai.com')) {
          final fixedEmail = rawEmail.replaceAll('@gmai.com', '@gmail.com');
          print('Attempting fallback 2: Correcting domain typo to $fixedEmail...');
          final retryTypo = await _connect.post(ApiEndpoints.loginUrl, {
            'email': fixedEmail,
            'password': password,
          });
          print('Fallback 2 Status Code: ${retryTypo.statusCode}');
          print('Fallback 2 Body: ${retryTypo.body}');
          if (retryTypo.statusCode == 200 || retryTypo.statusCode == 201) {
            response = retryTypo;
            emailController.text = fixedEmail;
          } else {
            // Also try fixed email with role: creator
            final retryTypoCreator = await _connect.post(ApiEndpoints.loginUrl, {
              'email': fixedEmail,
              'password': password,
              'role': 'creator',
            });
            if (retryTypoCreator.statusCode == 200 || retryTypoCreator.statusCode == 201) {
              response = retryTypoCreator;
              emailController.text = fixedEmail;
            }
          }
        }

        // Fallback 3: Creator specific endpoints if exists
        if (response.statusCode == 404) {
          final creatorEndpoints = [
            '${BaseUrl.baseUrl}auth/creator/login',
            '${BaseUrl.baseUrl}creator/login',
            '${BaseUrl.baseUrl}creators/login',
          ];
          for (final ep in creatorEndpoints) {
            print('Attempting fallback endpoint: $ep...');
            final retryEp = await _connect.post(ep, {
              'email': emailController.text.trim(),
              'password': password,
            });
            if (retryEp.statusCode == 200 || retryEp.statusCode == 201) {
              response = retryEp;
              break;
            }
          }
        }
      }

      print('Final Status Code to process: ${response.statusCode}');
      print('========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        String role = '';

        if (response.body != null && response.body is Map) {
          final resMap = response.body as Map;
          role = (resMap['role'] ??
                  resMap['user']?['role'] ??
                  resMap['data']?['role'] ??
                  resMap['data']?['user']?['role'] ??
                  resMap['user_type'] ??
                  '')
              .toString()
              .toLowerCase()
              .trim();
        }

        print('Extracted Role: $role');
        print('========================================');

        if (role == 'creator') {
          Get.snackbar(
            'Success',
            'Login successful as Creator',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          await Future.delayed(const Duration(milliseconds: 500));
          Get.offAllNamed('/creator-dashboard');
        } else if (role == 'customer') {
          Get.snackbar(
            'Success',
            'Login successful as Customer',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          await Future.delayed(const Duration(milliseconds: 500));
          Get.offAllNamed('/home');
        } else {
          // If role is undefined or unrecognized, default to HomeView
          print('Unrecognized role "$role", defaulting to HomeView (/home)');
          Get.snackbar(
            'Success',
            'Login successful',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          await Future.delayed(const Duration(milliseconds: 500));
          Get.offAllNamed('/home');
        }
      } else {
        print('========================================');
        String errorMessage = 'Login failed. Please check your credentials.';
        if (response.body is Map) {
          final resMap = response.body as Map;
          if (resMap['detail'] != null) {
            errorMessage = resMap['detail'].toString();
          } else if (resMap['message'] != null) {
            errorMessage = resMap['message'].toString();
          } else if (resMap['error'] != null) {
            errorMessage = resMap['error'].toString();
          }
        } else if (response.statusText != null && response.statusText!.isNotEmpty) {
          errorMessage = response.statusText!;
        }

        Get.snackbar(
          'Login Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Login API Exception: $e');
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

  void goToRegister() {
    Get.toNamed('/register');
  }

  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
