import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/base_url.dart';
import '../../../core/services/session_service.dart';

class StateModel {
  final int id;
  final String name;

  StateModel({required this.id, required this.name});
}

class ProfileSetupController extends GetxController {
  final isLoading = true.obs;
  final isSaving = false.obs;

  // Creator User ID
  final userId = 24.obs;

  // Text editing controllers for editable fields
  final displayNameController = TextEditingController();
  final bioController = TextEditingController();
  final descriptionController = TextEditingController();

  // Observable profile fields
  final displayName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final bio = ''.obs;
  final description = ''.obs;
  final referralCode = ''.obs;
  final gender = ''.obs;
  final stateName = ''.obs;
  final stateId = Rx<int?>(null);
  final profilePhoto = ''.obs;

  // States
  final statesList = <StateModel>[].obs;
  final isStatesLoading = false.obs;

  // Locally selected image
  final selectedImagePath = ''.obs;
  File? selectedImage;

  final ImagePicker _imagePicker = ImagePicker();
  final GetConnect _connect = GetConnect();

  @override
  void onInit() {
    super.onInit();
    _connect.timeout = const Duration(seconds: 40);
    initAndFetchProfile();
    fetchStates();
  }

  @override
  void onClose() {
    displayNameController.dispose();
    bioController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Full Image URL helper for network images
  String get fullPhotoUrl {
    final photo = profilePhoto.value.trim();
    if (photo.isEmpty) return '';
    if (photo.startsWith('http://') || photo.startsWith('https://')) {
      return Uri.encodeFull(photo);
    }
    final cleanBase = BaseUrl.baseUrl.replaceAll(RegExp(r'/+$'), '');
    final cleanPath = photo.replaceAll(RegExp(r'^/+'), '').replaceAll(r'\', '/');
    return Uri.encodeFull('$cleanBase/$cleanPath');
  }

  // ===========================================================================
  // 1. GET API: http://62.72.31.253:8002/users/{user_id}
  // ===========================================================================
  Future<void> initAndFetchProfile() async {
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

    await fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      final targetUserId = userId.value;
      final url = ApiEndpoints.userProfileUrl(targetUserId);
      final token = await SessionService.getToken();
      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      print('========================================');
      print('[GET_USER] Request URL: $url');
      print('[GET_USER] Fetching Profile for User ID: $targetUserId');

      final response = await _connect.get(url, headers: headers);

      print('[GET_USER] Response StatusCode: ${response.statusCode}');
      print('[GET_USER] Response Body: ${response.body}');
      print('========================================');

      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> data = {};
        if (response.body is Map) {
          final resMap = response.body as Map;
          if (resMap['data'] != null && resMap['data'] is Map) {
            data = Map<String, dynamic>.from(resMap['data']);
          } else {
            data = Map<String, dynamic>.from(resMap);
          }
        }

        if (data['id'] != null) {
          final fetchedId = int.tryParse(data['id'].toString()) ?? 0;
          if (fetchedId > 0) userId.value = fetchedId;
        }

        displayName.value = (data['display_name'] ?? '').toString();
        displayNameController.text = displayName.value;

        email.value = (data['email'] ?? '').toString();
        phone.value = (data['phone'] ?? '').toString();

        bio.value = (data['bio'] ?? '').toString();
        bioController.text = bio.value;

        description.value = (data['description'] ?? '').toString();
        descriptionController.text = description.value;

        referralCode.value = (data['referral_code'] ?? '').toString();
        gender.value = (data['gender'] ?? '').toString();

        if (data['state_id'] != null) {
          stateId.value = int.tryParse(data['state_id'].toString());
        }
        if (data['state'] != null && data['state'] is Map) {
          stateName.value = (data['state']['name'] ?? '').toString();
          if (stateId.value == null && data['state']['id'] != null) {
            stateId.value = int.tryParse(data['state']['id'].toString());
          }
        } else if (data['state_name'] != null) {
          stateName.value = data['state_name'].toString();
        }

        final photo = (data['profile_photo'] ?? '').toString().trim();
        print('[GET_USER] Profile Photo field value: "$photo"');
        if (photo.isNotEmpty) {
          profilePhoto.value = photo;
          selectedImage = null;
          selectedImagePath.value = '';
          print('[GET_USER] Full Photo URL: $fullPhotoUrl');
        }
      }
    } catch (e) {
      print('[GET_USER] Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch list of states
  Future<void> fetchStates() async {
    isStatesLoading.value = true;
    try {
      final response = await _connect.get(ApiEndpoints.statesUrl);
      if (response.statusCode == 200 && response.body != null) {
        dynamic list = response.body;
        if (list is Map) {
          if (list['data'] is List) {
            list = list['data'];
          } else if (list['states'] is List) {
            list = list['states'];
          }
        }

        if (list is List) {
          final List<StateModel> parsed = [];
          for (int i = 0; i < list.length; i++) {
            final item = list[i];
            if (item is Map) {
              final id = int.tryParse(item['id']?.toString() ?? '') ?? (i + 1);
              final name = (item['name'] ?? item['state_name'] ?? 'State $id').toString();
              parsed.add(StateModel(id: id, name: name));
            }
          }
          if (parsed.isNotEmpty) {
            statesList.assignAll(parsed);
          }
        }
      }
    } catch (e) {
      print('[STATES] Error: $e');
    } finally {
      isStatesLoading.value = false;
    }
  }

  void selectState(StateModel state) {
    stateId.value = state.id;
    stateName.value = state.name;
  }

  // ===========================================================================
  // Profile Photo Picker
  // ===========================================================================
  void pickImage() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: Color(0xFF17132F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF58D6).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: Color(0xFFFF58D6)),
                ),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Get.back();
                  pickImageFromSource(ImageSource.camera);
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8D32F0).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library_rounded, color: Color(0xFF8D32F0)),
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Get.back();
                  pickImageFromSource(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> pickImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        selectedImagePath.value = pickedFile.path;

        print('[IMAGE_PICK] Picked image path: ${pickedFile.path}');

        Get.snackbar(
          'Photo Selected',
          'Tap "Save Profile" to save your new photo.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF17132F),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Color(0xFFFF58D6)),
        );
      }
    } catch (e) {
      print('[IMAGE_PICK] Error: $e');
    }
  }

  // ===========================================================================
  // 2. PUT API: http://62.72.31.253:8002/users/{user_id}
  // Parameters: display_name, email, phone, state_id, bio, profile_photo
  // ===========================================================================
  Future<void> saveProfile() async {
    final updatedDisplayName = displayNameController.text.trim().isNotEmpty
        ? displayNameController.text.trim()
        : displayName.value.trim();

    if (updatedDisplayName.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a display name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final userBio = bioController.text.trim();
    final userDesc = descriptionController.text.trim();
    String updatedBio = userBio;
    if (updatedBio.isEmpty && userDesc.isNotEmpty) {
      updatedBio = userDesc;
    }

    final updatedEmail = email.value.trim();
    final updatedPhone = phone.value.trim();
    final targetStateId = (stateId.value != null && stateId.value! > 0) ? stateId.value! : 1;

    isSaving.value = true;
    _connect.timeout = const Duration(seconds: 40);

    try {
      int id = userId.value;
      if (id <= 0) {
        id = await SessionService.getUserId();
        if (id <= 0) id = 24;
        userId.value = id;
      }

      final url = ApiEndpoints.userProfileUrl(id);
      final token = await SessionService.getToken();
      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      // Helper to build a clean FormData instance
      Future<FormData> createFormData({bool includeContact = true}) async {
        final map = <String, dynamic>{
          'display_name': updatedDisplayName,
          'bio': updatedBio,
          'state_id': targetStateId.toString(),
        };

        if (includeContact) {
          if (updatedEmail.isNotEmpty) map['email'] = updatedEmail;
          if (updatedPhone.isNotEmpty) map['phone'] = updatedPhone;
        }

        if (selectedImage != null && await selectedImage!.exists()) {
          final bytes = await selectedImage!.readAsBytes();
          map['profile_photo'] = MultipartFile(
            bytes,
            filename: 'profile_${id}.jpg',
            contentType: 'image/jpeg',
          );
        }

        return FormData(map);
      }

      print('========================================');
      print('[PUT_USER] URL: $url');
      print('[PUT_USER] Form Fields: display_name="$updatedDisplayName", bio="$updatedBio", state_id=$targetStateId, hasNewPhoto=${selectedImage != null}');

      // Attempt 1: PUT with clean FormData (NO query params in URL to avoid list duplicate error)
      Response response = await _connect.put(url, await createFormData(includeContact: true), headers: headers);

      print('[PUT_USER] Attempt 1 StatusCode: ${response.statusCode}');
      print('[PUT_USER] Attempt 1 Body: ${response.body}');

      // Attempt 2: If 500 error, retry without email/phone (avoids DB unique constraint violation)
      if (response.statusCode == 500) {
        print('[PUT_USER] Attempt 1 failed with 500. Retrying without email/phone...');
        final resp2 = await _connect.put(url, await createFormData(includeContact: false), headers: headers);
        print('[PUT_USER] Attempt 2 StatusCode: ${resp2.statusCode}');
        print('[PUT_USER] Attempt 2 Body: ${resp2.body}');
        if (resp2.isOk || resp2.statusCode == 200 || resp2.statusCode == 201) {
          response = resp2;
        }
      }

      print('========================================');

      if (response.isOk || response.statusCode == 200 || response.statusCode == 201) {
        // Save display name to local session
        await SessionService.saveLoginSession(
          userId: id,
          role: 'creator',
          displayName: updatedDisplayName,
          token: token,
        );

        // Fetch fresh profile from GET API to sync server state
        await fetchUserProfile();

        // Update local observables
        displayName.value = updatedDisplayName;
        bio.value = updatedBio;

        String msg = 'Profile updated successfully!';
        if (response.body is Map && response.body['message'] != null) {
          msg = response.body['message'].toString();
        }

        Get.snackbar(
          'Success',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0F3223),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Color(0xFF00C853)),
        );
      } else {
        String errorMsg = 'Failed to update profile (Status: ${response.statusCode})';
        if (response.body is Map) {
          if (response.body['message'] != null) {
            errorMsg = response.body['message'].toString();
          } else if (response.body['detail'] != null) {
            errorMsg = response.body['detail'].toString();
          }
        }
        Get.snackbar(
          'Update Failed',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('[PUT_USER] Exception: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
