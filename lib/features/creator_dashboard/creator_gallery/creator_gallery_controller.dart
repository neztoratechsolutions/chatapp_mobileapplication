import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/base_url.dart';
import '../../../core/services/session_service.dart';

class GalleryModel {
  final int id;
  final int userId;
  final String photo;
  final String? createdAt;
  final String? updatedAt;

  GalleryModel({
    required this.id,
    required this.userId,
    required this.photo,
    this.createdAt,
    this.updatedAt,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      photo: (json['photo'] ?? '').toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  String get fullPhotoUrl {
    final clean = photo.trim();
    if (clean.isEmpty) return '';
    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return Uri.encodeFull(clean);
    }
    final cleanBase = BaseUrl.baseUrl.replaceAll(RegExp(r'/+$'), '');
    final cleanPath = clean.replaceAll(RegExp(r'^/+'), '').replaceAll(r'\', '/');
    return Uri.encodeFull('$cleanBase/$cleanPath');
  }
}

class CreatorGalleryController extends GetxController {
  // Creator User ID
  final userId = 24.obs;

  // Selected tab: 'Dashboard', 'Profile Setup', 'KYC', 'Gallery', 'Pricing'
  final selectedTab = 'Gallery'.obs;

  // Status: Online / Offline
  final isOnline = true.obs;

  // Loading, Uploading, Deleting states
  final isLoading = false.obs;
  final isUploading = false.obs;
  final deletingId = 0.obs;

  // List of uploaded photos from API (up to 8)
  final galleryList = <GalleryModel>[].obs;

  final GetConnect _connect = GetConnect();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _connect.timeout = const Duration(seconds: 30);
    initUserAndFetch();
  }

  Future<void> initUserAndFetch() async {
    int id = 0;
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      id = int.tryParse(args['id']?.toString() ?? args['user_id']?.toString() ?? '') ?? 0;
    }
    if (id <= 0) {
      id = await SessionService.getUserId();
    }
    if (id <= 0) {
      id = 24; // Default creator user_id
    }
    userId.value = id;
    await fetchGallery();
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
    } else if (tabName == 'Pricing') {
      Get.offNamed('/creator-pricing');
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

  // ===========================================================================
  // 1. GET API: http://62.72.31.253:8002/gallery/user/{user_id}
  // ===========================================================================
  Future<void> fetchGallery() async {
    isLoading.value = true;
    try {
      final targetUserId = userId.value;
      final url = ApiEndpoints.userGalleryUrl(targetUserId);
      final token = await SessionService.getToken();
      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      print('========================================');
      print('[GET_GALLERY] Request URL: $url');
      print('[GET_GALLERY] Fetching gallery for User ID: $targetUserId');

      final response = await _connect.get(url, headers: headers);

      print('[GET_GALLERY] Response StatusCode: ${response.statusCode}');
      print('[GET_GALLERY] Response Body: ${response.body}');
      print('========================================');

      if (response.statusCode == 200 && response.body != null) {
        final List<GalleryModel> loadedList = [];

        if (response.body is List) {
          for (var item in response.body as List) {
            if (item is Map) {
              loadedList.add(GalleryModel.fromJson(Map<String, dynamic>.from(item)));
            }
          }
        } else if (response.body is Map) {
          final resMap = response.body as Map;
          if (resMap['data'] != null && resMap['data'] is List) {
            for (var item in resMap['data'] as List) {
              if (item is Map) {
                loadedList.add(GalleryModel.fromJson(Map<String, dynamic>.from(item)));
              }
            }
          }
        }

        galleryList.assignAll(loadedList);
      } else {
        print('[GET_GALLERY] Empty or non-200 status: ${response.statusCode}');
      }
    } catch (e) {
      print('[GET_GALLERY] Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================================
  // 2. POST API: http://62.72.31.253:8002/gallery/
  // ===========================================================================
  Future<void> pickAndUploadImage({ImageSource source = ImageSource.gallery}) async {
    if (galleryList.length >= 8) {
      Get.snackbar(
        'Limit Reached',
        'You can upload up to 8 photos only.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF17132F),
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
      );
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      await uploadImageFile(file);
    } catch (e) {
      print('[IMAGE_PICK] Error: $e');
    }
  }

  Future<void> uploadImageFile(File file) async {
    isUploading.value = true;
    try {
      final targetUserId = userId.value;
      final bytes = await file.readAsBytes();
      final filename = file.path.split(Platform.pathSeparator).last;
      final token = await SessionService.getToken();

      // Pass user_id as query param and also in FormData to satisfy any backend schema
      final url = '${ApiEndpoints.galleryUrl}?user_id=$targetUserId';

      final formData = FormData({
        'user_id': targetUserId.toString(),
        'photo': MultipartFile(
          bytes,
          filename: filename.isNotEmpty ? filename : 'gallery_image.jpg',
          contentType: 'image/jpeg',
        ),
      });

      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      print('========================================');
      print('[POST_GALLERY] Request URL: $url');
      print('[POST_GALLERY] Uploading photo for User ID: $targetUserId, file: $filename (${bytes.length} bytes)');

      final response = await _connect.post(url, formData, headers: headers);

      print('[POST_GALLERY] Response StatusCode: ${response.statusCode}');
      print('[POST_GALLERY] Response Body: ${response.body}');
      print('========================================');

      if (response.statusCode == 201 ||
          response.statusCode == 200 ||
          (response.body is Map && response.body['status_code'] == 201)) {
        Get.snackbar(
          'Success',
          'Photo uploaded successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0F3223),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF00C853)),
        );
        // Refresh gallery from backend
        await fetchGallery();
      } else {
        String errorMsg = 'Failed to upload photo';
        if (response.body is Map && response.body['message'] != null) {
          errorMsg = response.body['message'].toString();
        }
        Get.snackbar(
          'Upload Failed',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF3B151E),
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.redAccent),
        );
      }
    } catch (e) {
      print('[POST_GALLERY] Exception: $e');
      Get.snackbar(
        'Error',
        'An error occurred while uploading photo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF3B151E),
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // ===========================================================================
  // 3. DELETE API: http://62.72.31.253:8002/gallery/user/{user_id}/{gallery_id}
  // ===========================================================================
  Future<void> deleteImage(int galleryId) async {
    deletingId.value = galleryId;
    try {
      final targetUserId = userId.value;
      final url = ApiEndpoints.deleteGalleryUrl(targetUserId, galleryId);
      final token = await SessionService.getToken();
      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      print('========================================');
      print('[DELETE_GALLERY] Request URL: $url');
      print('[DELETE_GALLERY] Deleting Gallery ID: $galleryId for User ID: $targetUserId');

      final response = await _connect.delete(url, headers: headers);

      print('[DELETE_GALLERY] Response StatusCode: ${response.statusCode}');
      print('[DELETE_GALLERY] Response Body: ${response.body}');
      print('========================================');

      if (response.statusCode == 200 || response.statusCode == 204 || response.isOk) {
        galleryList.removeWhere((item) => item.id == galleryId);
        Get.snackbar(
          'Deleted',
          'Photo deleted from gallery.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF17132F),
          colorText: Colors.white,
          icon: const Icon(Icons.delete_outline, color: Colors.white70),
        );
      } else {
        String errorMsg = 'Failed to delete photo';
        if (response.body is Map && response.body['message'] != null) {
          errorMsg = response.body['message'].toString();
        }
        Get.snackbar(
          'Delete Failed',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF3B151E),
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.redAccent),
        );
      }
    } catch (e) {
      print('[DELETE_GALLERY] Exception: $e');
      Get.snackbar(
        'Error',
        'An error occurred while deleting photo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF3B151E),
        colorText: Colors.white,
      );
    } finally {
      deletingId.value = 0;
    }
  }
}
