import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;
  final isCustomer = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
    void toggleAccountType(bool customer) {
    isCustomer.value = customer;
  }

  void login() {
    // TODO: replace with real authentication logic
    if (isCustomer.value) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/creator-dashboard');
    }
  }

  void goToRegister() {
    Get.toNamed('/register');
  }

  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }
}
