import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/models/user_model.dart';

class StateModel {
  final int id;
  final String name;

  StateModel({required this.id, required this.name});
}

class RegisterController extends GetxController {
  final fullNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isCustomer = true.obs;
  final isPasswordHidden = true.obs;
  final isRegistering = false.obs;

  // Gender
  final genderOptions = const ['Male', 'Female', 'Other'];
  final selectedGender = Rx<String?>(null);

  // States
  final statesList = <StateModel>[].obs;
  final selectedStateId = Rx<int?>(null);
  final isStatesLoading = false.obs;

  final GetConnect _connect = GetConnect();

  @override
  void onInit() {
    super.onInit();
    fetchStates();
  }

  Future<void> fetchStates() async {
    isStatesLoading.value = true;
    try {
      print('========================================');
      print('States API Endpoint: ${ApiEndpoints.statesUrl}');
      final response = await _connect.get(ApiEndpoints.statesUrl);
      print('States API Response Status Code: ${response.statusCode}');
      print('========================================');

      if (response.statusCode == 200 && response.body != null) {
        dynamic data = response.body;
        List<dynamic> list = [];

        if (data is List) {
          list = data;
        } else if (data is Map) {
          if (data['data'] is List) {
            list = data['data'];
          } else if (data['states'] is List) {
            list = data['states'];
          } else if (data['results'] is List) {
            list = data['results'];
          }
        }

        final List<StateModel> parsed = [];
        for (int i = 0; i < list.length; i++) {
          final item = list[i];
          if (item is Map) {
            final id = item['id'] is int
                ? item['id'] as int
                : int.tryParse(item['id']?.toString() ?? '') ?? (i + 1);
            final name = (item['name'] ?? item['state_name'] ?? item['state'] ?? item['title'] ?? 'State $id').toString();
            parsed.add(StateModel(id: id, name: name));
          } else if (item != null) {
            parsed.add(StateModel(id: i + 1, name: item.toString()));
          }
        }

        if (parsed.isNotEmpty) {
          statesList.assignAll(parsed);
          selectedStateId.value = parsed.first.id;
        }
      }
    } catch (e) {
      print('States API Error: $e');
    } finally {
      isStatesLoading.value = false;
    }
  }

  void toggleAccountType(bool customer) {
    isCustomer.value = customer;
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> register() async {
    final name = fullNameController.text.trim();
    final phone = mobileController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final role = isCustomer.value ? 'customer' : 'creator';

    // 1. Full name validation
    if (name.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your full name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (name.length < 3) {
      Get.snackbar(
        'Validation Error',
        'Full name must be at least 3 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // 2. Phone validation (10 digits)
    if (phone.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid 10-digit mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // 3. Email validation
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

    // 4. Password validation
    if (password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a password',
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

    // 5. Gender validation
    if (selectedGender.value == null || selectedGender.value!.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select your gender',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // 6. State validation
    if (selectedStateId.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select a state',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // API Payload matching schema
    final body = {
      'email': email,
      'phone': phone,
      'password': password,
      'display_name': name,
      'bio': '',
      'description': '',
      'state_id': selectedStateId.value ?? 1,
      'profile_photo': '',
      'gender': selectedGender.value!,
      'role': role,
    };

    isRegistering.value = true;

    try {
      print('========================================');
      print('Register API Endpoint: ${ApiEndpoints.registerUrl}');
      print('Register API Request Body: $body');

      final response = await _connect.post(ApiEndpoints.registerUrl, body);

      print('Register API Response Status Code: ${response.statusCode}');
      print('Register API Response Body: ${response.body}');
      print('========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        UserModel? registeredUser;
        if (response.body != null && response.body is Map) {
          try {
            registeredUser = UserModel.fromJson(Map<String, dynamic>.from(response.body));
            print('Registered User ID: ${registeredUser.id}');
            print('Registered Referral Code: ${registeredUser.referralCode}');
          } catch (e) {
            print('UserModel parsing error: $e');
          }
        }

        final displayRole = (registeredUser?.role ?? role).capitalizeFirst ?? 'User';
        Get.snackbar(
          'Success',
          'Registered successfully as $displayRole',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 600));
        Get.offNamed('/login');
      } else {
        String errorMessage = 'Registration failed. Please try again.';
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
          'Registration Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Register API Exception: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isRegistering.value = false;
    }
  }

  void goToLogin() {
    Get.offNamed('/login');
  }

  @override
  void onClose() {
    fullNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
