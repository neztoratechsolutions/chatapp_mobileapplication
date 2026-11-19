import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/services/session_service.dart';

class CreatorPricingController extends GetxController {
  // User ID (dynamic creator id)
  final userId = 24.obs;

  // Pricing ID from database (if pricing already created)
  final pricingId = 0.obs;
  final hasExistingPricing = false.obs;

  // Selected tab: 'Dashboard', 'Profile Setup', 'KYC', 'Gallery', 'Pricing'
  final selectedTab = 'Pricing'.obs;

  // Status: Online / Offline
  final isOnline = true.obs;

  // Loading & Action states
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isDeleting = false.obs;

  // Pricing values (RxDouble)
  final chatRate = 100.0.obs;
  final voiceCallRate = 500.0.obs;
  final videoCallRate = 1000.0.obs;

  // Text editing controllers for quick manual edit
  late final TextEditingController chatController;
  late final TextEditingController voiceController;
  late final TextEditingController videoController;

  final GetConnect _connect = GetConnect();

  @override
  void onInit() {
    super.onInit();
    _connect.timeout = const Duration(seconds: 30);
    chatController = TextEditingController(text: chatRate.value.toInt().toString());
    voiceController = TextEditingController(text: voiceCallRate.value.toInt().toString());
    videoController = TextEditingController(text: videoCallRate.value.toInt().toString());

    initUserAndFetchPricing();
  }

  @override
  void onClose() {
    chatController.dispose();
    voiceController.dispose();
    videoController.dispose();
    super.onClose();
  }

  Future<void> initUserAndFetchPricing() async {
    int id = 0;
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      id = int.tryParse(args['id']?.toString() ?? args['user_id']?.toString() ?? '') ?? 0;
    }
    if (id <= 0) {
      id = await SessionService.getUserId();
    }
    if (id <= 0) {
      id = 24; // Default creator user id
    }
    userId.value = id;

    await fetchPricingDetails();
  }

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
  }

  void changeTab(String tabName) {
    if (tabName == 'Dashboard') {
      Get.offNamed('/creator-dashboard');
    } else if (tabName == 'Profile Setup') {
      Get.offNamed('/profile-setup');
    } else if (tabName == 'KYC') {
      Get.offNamed('/kyc-verify');
    } else if (tabName == 'Gallery') {
      Get.offNamed('/creator-gallery');
    } else if (tabName == 'Earnings') {
      Get.offNamed('/creator-earnings');
    } else if (tabName == 'Gifts') {
      Get.offNamed('/gifts-received');
    } else if (tabName == 'Inbox') {
      Get.offNamed('/inbox');
    } else {
      selectedTab.value = tabName;
    }
  }

  // Update rates with sync to text controllers
  void setChatRate(double value) {
    final rounded = value.roundToDouble();
    chatRate.value = rounded;
    chatController.text = rounded.toInt().toString();
  }

  void setVoiceRate(double value) {
    final rounded = value.roundToDouble();
    voiceCallRate.value = rounded;
    voiceController.text = rounded.toInt().toString();
  }

  void setVideoRate(double value) {
    final rounded = value.roundToDouble();
    videoCallRate.value = rounded;
    videoController.text = rounded.toInt().toString();
  }

  // Handle manual input in text fields
  void onChatTextChanged(String text) {
    final val = double.tryParse(text);
    if (val != null && val >= 0) {
      chatRate.value = val;
    }
  }

  void onVoiceTextChanged(String text) {
    final val = double.tryParse(text);
    if (val != null && val >= 0) {
      voiceCallRate.value = val;
    }
  }

  void onVideoTextChanged(String text) {
    final val = double.tryParse(text);
    if (val != null && val >= 0) {
      videoCallRate.value = val;
    }
  }

  // ===========================================================================
  // 1. GET API: /pricing-details/user/{user_id}
  // ===========================================================================
  Future<void> fetchPricingDetails() async {
    isLoading.value = true;
    try {
      final targetUserId = userId.value;
      final url = ApiEndpoints.userPricingUrl(targetUserId);
      final token = await SessionService.getToken();
      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      print('========================================');
      print('[GET_PRICING] Request URL: $url');
      print('[GET_PRICING] Fetching pricing for User ID: $targetUserId');

      final response = await _connect.get(url, headers: headers);

      print('[GET_PRICING] Response StatusCode: ${response.statusCode}');
      print('[GET_PRICING] Response Body: ${response.body}');
      print('========================================');

      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic>? dataMap;

        if (response.body is Map) {
          final map = response.body as Map;
          if (map['data'] != null) {
            if (map['data'] is Map) {
              dataMap = Map<String, dynamic>.from(map['data']);
            } else if (map['data'] is List && (map['data'] as List).isNotEmpty) {
              dataMap = Map<String, dynamic>.from((map['data'] as List).first);
            }
          } else {
            dataMap = Map<String, dynamic>.from(map);
          }
        } else if (response.body is List && (response.body as List).isNotEmpty) {
          dataMap = Map<String, dynamic>.from((response.body as List).first);
        }

        if (dataMap != null) {
          final fetchedId = int.tryParse(dataMap['id']?.toString() ?? '0') ?? 0;
          if (fetchedId > 0) {
            pricingId.value = fetchedId;
            hasExistingPricing.value = true;
          }

          if (dataMap['chat_amount'] != null) {
            final val = double.tryParse(dataMap['chat_amount'].toString());
            if (val != null) setChatRate(val);
          }

          if (dataMap['voice_call_amount'] != null) {
            final val = double.tryParse(dataMap['voice_call_amount'].toString());
            if (val != null) setVoiceRate(val);
          }

          if (dataMap['video_call_amount'] != null) {
            final val = double.tryParse(dataMap['video_call_amount'].toString());
            if (val != null) setVideoRate(val);
          }
        }
      } else {
        print('[GET_PRICING] No pricing found or non-200 status: ${response.statusCode}');
      }
    } catch (e) {
      print('[GET_PRICING] Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================================
  // 2. SAVE (POST or PUT) API
  // POST: /pricing-details/ (if new)
  // PUT:  /pricing-details/{pricing_id} (if existing)
  // ===========================================================================
  Future<void> savePricing() async {
    isSaving.value = true;
    try {
      final targetUserId = userId.value;
      final token = await SessionService.getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final body = <String, dynamic>{
        'user_id': targetUserId,
        'chat_amount': chatRate.value == chatRate.value.roundToDouble()
            ? chatRate.value.toInt()
            : chatRate.value,
        'voice_call_amount': voiceCallRate.value == voiceCallRate.value.roundToDouble()
            ? voiceCallRate.value.toInt()
            : voiceCallRate.value,
        'video_call_amount': videoCallRate.value == videoCallRate.value.roundToDouble()
            ? videoCallRate.value.toInt()
            : videoCallRate.value,
      };

      Response response;

      // If existing pricing record exists, update using PUT
      if (hasExistingPricing.value && pricingId.value > 0) {
        final putUrl = ApiEndpoints.pricingIdUrl(pricingId.value);
        print('========================================');
        print('[PUT_PRICING] Request URL: $putUrl');
        print('[PUT_PRICING] Body: ${jsonEncode(body)}');

        response = await _connect.put(putUrl, body, headers: headers);

        print('[PUT_PRICING] Response StatusCode: ${response.statusCode}');
        print('[PUT_PRICING] Response Body: ${response.body}');
        print('========================================');

        // If PUT returns 404 or method not allowed, try fallback to POST
        if (response.statusCode == 404 || response.statusCode == 405) {
          print('[PUT_PRICING] PUT failed with ${response.statusCode}, falling back to POST');
          final postUrl = ApiEndpoints.pricingDetailsUrl;
          response = await _connect.post(postUrl, body, headers: headers);
          print('[POST_FALLBACK] Response StatusCode: ${response.statusCode}');
          print('[POST_FALLBACK] Response Body: ${response.body}');
        }
      } else {
        // Create new pricing using POST
        final postUrl = ApiEndpoints.pricingDetailsUrl;
        print('========================================');
        print('[POST_PRICING] Request URL: $postUrl');
        print('[POST_PRICING] Body: ${jsonEncode(body)}');

        response = await _connect.post(postUrl, body, headers: headers);

        print('[POST_PRICING] Response StatusCode: ${response.statusCode}');
        print('[POST_PRICING] Response Body: ${response.body}');
        print('========================================');
      }

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          (response.body is Map && (response.body['status_code'] == 200 || response.body['status_code'] == 201))) {
        // Extract updated or created ID
        Map<String, dynamic>? resData;
        if (response.body is Map) {
          final map = response.body as Map;
          if (map['data'] != null && map['data'] is Map) {
            resData = Map<String, dynamic>.from(map['data']);
          } else {
            resData = Map<String, dynamic>.from(map);
          }
        }
        if (resData != null && resData['id'] != null) {
          final newId = int.tryParse(resData['id'].toString()) ?? 0;
          if (newId > 0) {
            pricingId.value = newId;
            hasExistingPricing.value = true;
          }
        }

        Get.snackbar(
          'Success',
          'Pricing details saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0F3223),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF00C853)),
        );
      } else {
        String msg = 'Failed to save pricing details';
        if (response.body is Map && response.body['message'] != null) {
          msg = response.body['message'].toString();
        }
        Get.snackbar(
          'Failed',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF3B151E),
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.redAccent),
        );
      }
    } catch (e) {
      print('[SAVE_PRICING] Exception: $e');
      Get.snackbar(
        'Error',
        'An error occurred while saving pricing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF3B151E),
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // ===========================================================================
  // 3. DELETE API: /pricing-details/{pricing_id}
  // ===========================================================================
  Future<void> deletePricing() async {
    if (pricingId.value <= 0) {
      Get.snackbar(
        'Info',
        'No saved pricing details to delete.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF17132F),
        colorText: Colors.white,
      );
      return;
    }

    isDeleting.value = true;
    try {
      final targetPricingId = pricingId.value;
      final url = ApiEndpoints.pricingIdUrl(targetPricingId);
      final token = await SessionService.getToken();
      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      print('========================================');
      print('[DELETE_PRICING] Request URL: $url');
      print('[DELETE_PRICING] Deleting Pricing ID: $targetPricingId');

      final response = await _connect.delete(url, headers: headers);

      print('[DELETE_PRICING] Response StatusCode: ${response.statusCode}');
      print('[DELETE_PRICING] Response Body: ${response.body}');
      print('========================================');

      if (response.statusCode == 200 || response.statusCode == 204 || response.isOk) {
        pricingId.value = 0;
        hasExistingPricing.value = false;

        // Reset to default starting rates
        setChatRate(100.0);
        setVoiceRate(500.0);
        setVideoRate(1000.0);

        Get.snackbar(
          'Deleted',
          'Pricing details reset successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF17132F),
          colorText: Colors.white,
          icon: const Icon(Icons.delete_outline, color: Colors.white70),
        );
      } else {
        String msg = 'Failed to delete pricing';
        if (response.body is Map && response.body['message'] != null) {
          msg = response.body['message'].toString();
        }
        Get.snackbar(
          'Delete Failed',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF3B151E),
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.redAccent),
        );
      }
    } catch (e) {
      print('[DELETE_PRICING] Exception: $e');
      Get.snackbar(
        'Error',
        'An error occurred while deleting pricing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF3B151E),
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }
}
