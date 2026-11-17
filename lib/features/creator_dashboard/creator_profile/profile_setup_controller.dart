import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/services/session_service.dart';

class ProfileSetupController extends GetxController {
  final isLoading = true.obs;
  final isSaving = false.obs;

  final userId = 24.obs;

  // Text editing controllers for editable fields
  final displayNameController = TextEditingController();
  final bioController = TextEditingController();
  final descriptionController = TextEditingController();

  // Observable fields matching API data
  final displayName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final bio = ''.obs;
  final description = ''.obs;
  final referralCode = ''.obs;
  final gender = ''.obs;
  final stateName = ''.obs;
  final profilePhoto = ''.obs;

  // Local image pick state
  final selectedImagePath = ''.obs;
  File? selectedImage;

  final ImagePicker _imagePicker = ImagePicker();
  final GetConnect _connect = GetConnect();

  @override
  void onInit() {
    super.onInit();
    _connect.timeout = const Duration(seconds: 30);
    fetchUserProfile();
  }

  /// GET baseUrl/users/{user_id} - Fetch creator profile data
  Future<void> fetchUserProfile() async {
    isLoading.value = true;

    try {
      int id = 0;
      if (Get.arguments != null && Get.arguments is Map) {
        final args = Get.arguments as Map;
        id = int.tryParse(args['id']?.toString() ?? args['user_id']?.toString() ?? '') ?? 0;
      }
      if (id <= 0) {
        id = await SessionService.getUserId();
      }
      if (id <= 0) {
        id = 24;
      }
      userId.value = id;

      final url = ApiEndpoints.userProfileUrl(id);
      final token = await SessionService.getToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      print('========================================');
      print('[GET_USER] Fetching: $url');

      final response = await _connect.get(url, headers: headers);

      print('[GET_USER] Response Status: ${response.statusCode}');
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
          if (fetchedId > 0) {
            userId.value = fetchedId;
          }
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

        if (data['state'] != null && data['state'] is Map) {
          stateName.value = (data['state']['name'] ?? '').toString();
        } else if (data['state_name'] != null) {
          stateName.value = data['state_name'].toString();
        }

        final photo = (data['profile_photo'] ?? '').toString().trim();
        if (photo.isNotEmpty) {
          profilePhoto.value = photo;
          selectedImage = null;
          selectedImagePath.value = '';
        }
      }
    } catch (e) {
      print('[GET_USER] Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

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
                subtitle: const Text(
                  'Use camera to take a new picture',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
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
                subtitle: const Text(
                  'Select an image from device gallery',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                onTap: () {
                  Get.back();
                  pickImageFromSource(ImageSource.gallery);
                },
              ),
              if (selectedImagePath.value.isNotEmpty || profilePhoto.value.isNotEmpty) ...[
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  ),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Get.back();
                    selectedImage = null;
                    selectedImagePath.value = '';
                    profilePhoto.value = '';
                  },
                ),
              ],
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
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        selectedImagePath.value = pickedFile.path;

        // Convert picked image to Base64 String format
        final bytes = await selectedImage!.readAsBytes();
        final b64 = base64Encode(bytes);
        profilePhoto.value = 'data:image/jpeg;base64,$b64';

        Get.snackbar(
          'Photo Selected',
          'Image ready. Tap "Save Profile" to update.',
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

  /// PUT baseUrl/users/{user_id} - Update image, name, bio, and description
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

    final updatedBio = bioController.text.trim().isNotEmpty
        ? bioController.text.trim()
        : bio.value.trim();

    final updatedDescription = descriptionController.text.trim().isNotEmpty
        ? descriptionController.text.trim()
        : description.value.trim();

    isSaving.value = true;
    _connect.timeout = const Duration(seconds: 30);

    try {
      int id = userId.value;
      if (id <= 0) {
        id = await SessionService.getUserId();
        if (id <= 0) id = 24;
        userId.value = id;
      }

      final baseUrlUser = ApiEndpoints.userProfileUrl(id);
      final token = await SessionService.getToken();

      // Ensure profile_photo string is updated if user picked a new file
      if (selectedImage != null && await selectedImage!.exists()) {
        final bytes = await selectedImage!.readAsBytes();
        profilePhoto.value = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      }

      final photoString = profilePhoto.value.trim();

      print('========================================');
      print('[PUT_USER] Starting update for User ID: $id');
      print('[PUT_USER] display_name: "$updatedDisplayName"');
      print('[PUT_USER] bio: "$updatedBio"');
      print('[PUT_USER] description: "$updatedDescription"');
      print('[PUT_USER] profile_photo length: ${photoString.length}');

      // 1. Build Query Parameters (in case backend expects FastAPI query parameters)
      final queryParams = <String, String>{
        'display_name': updatedDisplayName,
        'name': updatedDisplayName,
        'bio': updatedBio,
        'description': updatedDescription,
        'about': updatedDescription,
        'about_me': updatedDescription,
      };

      // Only add to query string if it is a short URL, not huge base64
      if (photoString.isNotEmpty && photoString.length < 500) {
        queryParams['profile_photo'] = photoString;
        queryParams['image'] = photoString;
      }

      final queryString = Uri(queryParameters: queryParams).query;
      final urlWithQuery = '$baseUrlUser?$queryString';

      // 2. Build JSON Body (in case backend expects JSON body)
      final jsonBody = <String, dynamic>{
        'display_name': updatedDisplayName,
        'name': updatedDisplayName,
        'bio': updatedBio,
        'description': updatedDescription,
        'about': updatedDescription,
        'about_me': updatedDescription,
        'profile_photo': photoString,
        'image': photoString,
      };

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      print('[PUT_USER] Sending PUT to: $urlWithQuery');
      print('[PUT_USER] Body: $jsonBody');

      // Attempt 1: PUT with URL Query Params + JSON Body
      Response response = await _connect.put(urlWithQuery, jsonBody, headers: headers);
      print('[PUT_USER] Attempt 1 Status: ${response.statusCode}, Body: ${response.body}');

      // Attempt 2: If 405 Method Not Allowed, retry with PATCH
      if (response.statusCode == 405) {
        print('[PUT_USER] Retrying with PATCH...');
        response = await _connect.patch(urlWithQuery, jsonBody, headers: headers);
        print('[PUT_USER] Attempt 2 PATCH Status: ${response.statusCode}');
      }

      // Check if response actually updated bio and description
      bool isDataUpdated = _checkIfUpdated(response.body, updatedBio, updatedDescription);

      // Attempt 3: If not updated, try PUT to base URL (without query params)
      if (!isDataUpdated) {
        print('[PUT_USER] Attempt 3: Retrying with standard baseUrl (no query in URL)...');
        final resp3 = await _connect.put(baseUrlUser, jsonBody, headers: headers);
        print('[PUT_USER] Attempt 3 Status: ${resp3.statusCode}, Body: ${resp3.body}');
        if (_checkIfUpdated(resp3.body, updatedBio, updatedDescription)) {
          response = resp3;
          isDataUpdated = true;
        }
      }

      // Attempt 4: If still not updated, try FormData (in case backend uses Form parameters)
      if (!isDataUpdated) {
        print('[PUT_USER] Attempt 4: Retrying with FormData...');
        final formMap = <String, dynamic>{
          'display_name': updatedDisplayName,
          'name': updatedDisplayName,
          'bio': updatedBio,
          'description': updatedDescription,
          'about': updatedDescription,
          'about_me': updatedDescription,
          'profile_photo': photoString,
          'image': photoString,
        };
        final formHeaders = {
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        };
        final resp4 = await _connect.put(baseUrlUser, FormData(formMap), headers: formHeaders);
        print('[PUT_USER] Attempt 4 Status: ${resp4.statusCode}, Body: ${resp4.body}');
        if (_checkIfUpdated(resp4.body, updatedBio, updatedDescription) || resp4.isOk) {
          response = resp4;
          isDataUpdated = true;
        }
      }

      print('========================================');
      print('[PUT_USER] Final Status: ${response.statusCode}, Body: ${response.body}');
      print('========================================');

      if (response.isOk || response.statusCode == 200 || response.statusCode == 201) {
        // Save display name to session
        await SessionService.saveLoginSession(
          userId: id,
          role: 'creator',
          displayName: updatedDisplayName,
          token: token,
        );

        // Fetch fresh profile from GET API to ensure updated data gets displayed
        await fetchUserProfile();

        // Also ensure local controllers and observables have the values
        displayName.value = updatedDisplayName;
        displayNameController.text = updatedDisplayName;
        bio.value = updatedBio;
        bioController.text = updatedBio;
        description.value = updatedDescription;
        descriptionController.text = updatedDescription;
        if (photoString.isNotEmpty) {
          profilePhoto.value = photoString;
        }

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
          icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF00C853)),
          duration: const Duration(seconds: 3),
        );
      } else {
        String errorMsg = 'Failed to update profile (${response.statusCode})';
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

  /// Check whether the response data actually contains the updated bio or description
  bool _checkIfUpdated(dynamic body, String expectedBio, String expectedDesc) {
    if (body is Map) {
      final data = (body['data'] != null && body['data'] is Map) ? body['data'] as Map : body;
      final resBio = (data['bio'] ?? '').toString().trim();
      final resDesc = (data['description'] ?? data['about'] ?? '').toString().trim();
      if (expectedBio.isNotEmpty && resBio == expectedBio) return true;
      if (expectedDesc.isNotEmpty && resDesc == expectedDesc) return true;
    }
    return false;
  }

  @override
  void onClose() {
    displayNameController.dispose();
    bioController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
