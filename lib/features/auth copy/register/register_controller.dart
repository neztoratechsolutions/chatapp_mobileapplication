import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final fullNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final selectedState = 'Maharashtra'.obs;
  final isCustomer = true.obs;
  final isPasswordHidden = true.obs;

  void toggleAccountType(bool customer) {
    isCustomer.value = customer;
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void register() {
    Get.snackbar(
      'Register',
      'Account created for ${fullNameController.text}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xF3FFFFFF),
    );
  }

  void goToLogin() {
    Get.offNamed('/login');
  }
}
