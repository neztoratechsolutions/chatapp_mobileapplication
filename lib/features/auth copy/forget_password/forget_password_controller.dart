import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();

  void sendResetLink() {
    Get.snackbar(
      'Reset Password',
      'Reset link sent to ${emailController.text}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xF3FFFFFF),
    );
  }

  void goToLogin() {
    Get.offNamed('/login');
  }
}
