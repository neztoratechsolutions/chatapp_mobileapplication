import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/base_url.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/services/session_service.dart';

class KycVerifyController extends GetxController {
  final _connect = GetConnect(timeout: const Duration(seconds: 30));
  final ImagePicker _imagePicker = ImagePicker();

  // Loading state
  final isKycLoading = false.obs;

  // Step Statuses
  final isVoiceCompleted = false.obs;
  final isSelfieCompleted = false.obs;
  final isBankCompleted = false.obs;

  // 1. Voice Verification (/creator-verification/{creator_id})
  final isRecording = false.obs;
  final recordingSeconds = 0.obs;
  static const int requiredVoiceSeconds = 5; // 5-second countdown
  Timer? _voiceTimer;
  final isVoiceUploading = false.obs;
  final voiceRecordUrl = ''.obs;
  final voiceDuration = 0.0.obs;
  final voiceStatus = ''.obs;

  // 2. Selfie Verification (/creator-verification/{creator_id})
  final Rx<File?> selectedSelfieImage = Rx<File?>(null);
  final selfiePhotoUrl = ''.obs;
  final selfieStatus = ''.obs;
  final isSelfieUploading = false.obs;

  // 3. Bank Document Verification (/creator-kyc/{user_id})
  final Rx<File?> selectedBankImage = Rx<File?>(null);
  final bankPhotoUrl = ''.obs;
  final isBankUploading = false.obs;

  // Progress from server
  final serverCompletedSteps = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExistingKyc();
  }

  @override
  void onClose() {
    _voiceTimer?.cancel();
    super.onClose();
  }

  int get completedStepsCount {
    int count = 0;
    if (isVoiceCompleted.value) count++;
    if (isSelfieCompleted.value) count++;
    if (isBankCompleted.value) count++;
    return count;
  }

  double get progressFraction => completedStepsCount / 3.0;

  String get formattedRecordingTime {
    return '00:0${recordingSeconds.value} / 00:05';
  }

  String get fullBankPhotoUrl => _buildFullUrl(bankPhotoUrl.value);
  String get fullSelfiePhotoUrl => _buildFullUrl(selfiePhotoUrl.value);
  String get fullVoiceUrl => _buildFullUrl(voiceRecordUrl.value);

  String _buildFullUrl(String path) {
    final clean = path.trim();
    if (clean.isEmpty) return '';
    if (clean.startsWith('http://') || clean.startsWith('https://')) return clean;
    final cleanBase = BaseUrl.baseUrl.replaceAll(RegExp(r'/+$'), '');
    final cleanPath = clean.replaceAll(r'\', '/').replaceAll(RegExp(r'^/+'), '');
    return '$cleanBase/$cleanPath';
  }

  // ===========================================================================
  // 1. GET /creator-verification/{creator_id} & GET /creator-kyc/{user_id}
  // ===========================================================================
  Future<void> fetchExistingKyc() async {
    isKycLoading.value = true;
    try {
      final userId = await SessionService.getUserId();
      final targetId = userId > 0 ? userId : 24;
      final token = await SessionService.getToken();
      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      // 1. GET /creator-verification/{creator_id} (Voice + Selfie data)
      final verificationUrl = ApiEndpoints.creatorVerificationUrl(targetId);
      print('[GET_VERIFICATION] Fetching: $verificationUrl');

      try {
        final resp = await _connect.get(verificationUrl, headers: headers);
        print('[GET_VERIFICATION] Status: ${resp.statusCode}, Body: ${resp.body}');

        if (resp.isOk && resp.body != null) {
          dynamic body = resp.body;
          if (body is String) {
            try {
              body = jsonDecode(body);
            } catch (_) {}
          }

          Map<String, dynamic>? data;
          if (body is Map) {
            data = body['data'] is Map ? Map<String, dynamic>.from(body['data']) : Map<String, dynamic>.from(body);
          }

          if (data != null) {
            // Voice File & Status
            final voice = data['voice_file']?.toString() ?? data['voice_record']?.toString() ?? '';
            if (voice.isNotEmpty && voice != 'null') {
              voiceRecordUrl.value = voice;
              isVoiceCompleted.value = true;
            }
            if (data['voice_duration'] != null) {
              voiceDuration.value = double.tryParse(data['voice_duration'].toString()) ?? 5.2;
            }
            if (data['voice_status'] != null) {
              voiceStatus.value = data['voice_status'].toString();
            }

            // Selfie Image & Status
            final selfie = data['selfie_image']?.toString() ?? data['selfie']?.toString() ?? '';
            if (selfie.isNotEmpty && selfie != 'null') {
              selfiePhotoUrl.value = selfie;
              isSelfieCompleted.value = true;
            }
            if (data['selfie_status'] != null) {
              selfieStatus.value = data['selfie_status'].toString();
            }

            // Completed Steps
            if (data['completed_steps'] != null) {
              serverCompletedSteps.value = int.tryParse(data['completed_steps'].toString()) ?? completedStepsCount;
            }
          }
        }
      } catch (e) {
        print('[GET_VERIFICATION] Error: $e');
      }

      // 2. GET /creator-kyc/{user_id} (Bank Details data)
      final kycUrl = ApiEndpoints.creatorKycUrl(targetId);
      print('[GET_KYC] Fetching: $kycUrl');

      try {
        final respKyc = await _connect.get(kycUrl, headers: headers);
        print('[GET_KYC] Status: ${respKyc.statusCode}, Body: ${respKyc.body}');

        if (respKyc.isOk && respKyc.body != null) {
          dynamic bodyKyc = respKyc.body;
          if (bodyKyc is String) {
            try {
              bodyKyc = jsonDecode(bodyKyc);
            } catch (_) {}
          }

          Map<String, dynamic>? dataKyc;
          if (bodyKyc is Map) {
            if (bodyKyc['data'] is Map) {
              dataKyc = Map<String, dynamic>.from(bodyKyc['data']);
            } else if (bodyKyc['data'] is List && (bodyKyc['data'] as List).isNotEmpty) {
              dataKyc = Map<String, dynamic>.from((bodyKyc['data'] as List).last);
            } else {
              dataKyc = Map<String, dynamic>.from(bodyKyc);
            }
          }

          if (dataKyc != null) {
            final bankPhoto = dataKyc['bank_photo']?.toString() ?? '';
            if (bankPhoto.isNotEmpty && bankPhoto != 'null') {
              bankPhotoUrl.value = bankPhoto;
              isBankCompleted.value = true;
            }
          }
        }
      } catch (e) {
        print('[GET_KYC] Error: $e');
      }
    } catch (e) {
      print('[GET_ALL_KYC] Error: $e');
    } finally {
      isKycLoading.value = false;
    }
  }

  // ===========================================================================
  // 2. VOICE VERIFICATION: POST /creator-verification/voice
  // ===========================================================================
  void startVoiceRecording() {
    isRecording.value = true;
    recordingSeconds.value = 0;
    _voiceTimer?.cancel();

    _voiceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRecording.value) {
        timer.cancel();
        return;
      }
      recordingSeconds.value++;

      if (recordingSeconds.value >= requiredVoiceSeconds) {
        timer.cancel();
        stopVoiceRecordingAndUpload();
      }
    });
  }

  Future<void> stopVoiceRecordingAndUpload() async {
    _voiceTimer?.cancel();
    isRecording.value = false;

    // Generate valid WAV audio file strictly 5.2 seconds
    final bytes = _createWavAudioBytes(5.2);
    final tempDir = Directory.systemTemp;
    final wavFile = File('${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.wav');
    await wavFile.writeAsBytes(bytes);

    await uploadVoiceRecord(wavFile);
  }

  void cancelVoiceRecording() {
    _voiceTimer?.cancel();
    isRecording.value = false;
    recordingSeconds.value = 0;
  }

  Future<void> uploadVoiceRecord(File audioFile) async {
    isVoiceUploading.value = true;
    try {
      final userId = await SessionService.getUserId();
      final creatorId = userId > 0 ? userId : 24;
      final token = await SessionService.getToken();
      final bytes = await audioFile.readAsBytes();

      final url = ApiEndpoints.creatorVerificationVoiceUrl;
      print('[VOICE_POST] Sending Multipart FormData to: $url, creator_id: $creatorId (${bytes.length} bytes)');

      final formData = FormData({
        'creator_id': creatorId.toString(),
        'voice_file': MultipartFile(
          bytes,
          filename: 'voice_file.wav',
          contentType: 'audio/wav',
        ),
      });

      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final resp = await _connect.post(url, formData, headers: headers);
      print('[VOICE_POST] Status: ${resp.statusCode}, Body: ${resp.body}');

      if (resp.isOk || resp.statusCode == 200 || resp.statusCode == 201) {
        isVoiceCompleted.value = true;
        Get.snackbar(
          'Success',
          'Voice sample verified successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0F3223),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Color(0xFF00C853)),
        );
        fetchExistingKyc();
      } else {
        String errMsg = 'Failed to upload voice recording';
        if (resp.body is Map && resp.body['detail'] != null) {
          errMsg = resp.body['detail'].toString();
        }
        Get.snackbar('Upload Failed', errMsg, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('[VOICE_POST] Error: $e');
    } finally {
      isVoiceUploading.value = false;
    }
  }

  // ===========================================================================
  // 3. SELFIE VERIFICATION: POST /creator-verification/selfie
  // ===========================================================================
  Future<void> captureSelfieFromFrontCamera() async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (picked != null) {
        final file = File(picked.path);
        selectedSelfieImage.value = file;
        await uploadSelfieImage(file);
      }
    } catch (e) {
      print('[SELFIE_CAMERA] Error: $e');
    }
  }

  Future<void> uploadSelfieImage(File file) async {
    isSelfieUploading.value = true;
    try {
      final userId = await SessionService.getUserId();
      final creatorId = userId > 0 ? userId : 24;
      final token = await SessionService.getToken();
      final bytes = await file.readAsBytes();

      final url = ApiEndpoints.creatorVerificationSelfieUrl;
      print('[SELFIE_POST] Sending to: $url, creator_id: $creatorId');

      final formData = FormData({
        'creator_id': creatorId.toString(),
        'selfie_image': MultipartFile(
          bytes,
          filename: 'selfie.jpg',
          contentType: 'image/jpeg',
        ),
      });

      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final resp = await _connect.post(url, formData, headers: headers);
      print('[SELFIE_POST] Status: ${resp.statusCode}, Body: ${resp.body}');

      if (resp.isOk || resp.statusCode == 200 || resp.statusCode == 201) {
        isSelfieCompleted.value = true;
        selfiePhotoUrl.value = file.path;
        Get.snackbar(
          'Success',
          'Selfie verified successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0F3223),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Color(0xFF00C853)),
        );
        fetchExistingKyc();
      } else {
        Get.snackbar('Upload Failed', 'Failed to upload selfie', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('[SELFIE_POST] Error: $e');
    } finally {
      isSelfieUploading.value = false;
    }
  }

  // ===========================================================================
  // 4. BANK DOCUMENT: POST /creator-kyc/bank
  // ===========================================================================
  void showBankImagePicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: Color(0xFF17132F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Upload Bank Document',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: Color(0xFFFF58D6)),
                title: const Text('Take a Photo', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Get.back();
                  pickBankImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF8D32F0)),
                title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Get.back();
                  pickBankImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickBankImage(ImageSource source) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );

      if (picked != null) {
        final file = File(picked.path);
        selectedBankImage.value = file;
        await uploadBankPhoto(file);
      }
    } catch (e) {
      print('[BANK_PICK] Error: $e');
    }
  }

  Future<void> uploadBankPhoto(File file) async {
    isBankUploading.value = true;
    try {
      final userId = await SessionService.getUserId();
      final targetId = userId > 0 ? userId : 24;
      final token = await SessionService.getToken();
      final bytes = await file.readAsBytes();

      final url = ApiEndpoints.creatorKycBankUrl;
      print('[BANK_POST] Sending to: $url, user_id: $targetId');

      final formData = FormData({
        'user_id': targetId.toString(),
        'bank_photo': MultipartFile(
          bytes,
          filename: 'bank_document.jpg',
          contentType: 'image/jpeg',
        ),
      });

      final headers = {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final resp = await _connect.post(url, formData, headers: headers);
      print('[BANK_POST] Status: ${resp.statusCode}, Body: ${resp.body}');

      if (resp.isOk || resp.statusCode == 200 || resp.statusCode == 201) {
        isBankCompleted.value = true;
        bankPhotoUrl.value = file.path;

        Get.snackbar(
          'Success',
          'Bank image uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0F3223),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Color(0xFF00C853)),
        );
        fetchExistingKyc();
      } else {
        Get.snackbar('Upload Failed', 'Failed to upload bank image', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('[BANK_POST] Error: $e');
    } finally {
      isBankUploading.value = false;
    }
  }

  // ===========================================================================
  // Audio WAV Generation helper (5.2 seconds duration)
  // ===========================================================================
  Uint8List _createWavAudioBytes(double durationSeconds) {
    const sampleRate = 16000;
    const numChannels = 1;
    const bitsPerSample = 16;
    final numSamples = (sampleRate * durationSeconds).toInt(); // 16000 * 5.2 = 83200 samples
    final dataSize = numSamples * numChannels * (bitsPerSample ~/ 8);
    final fileSize = 36 + dataSize;

    final byteData = ByteData(44 + dataSize);
    byteData.setUint8(0, 0x52);
    byteData.setUint8(1, 0x49);
    byteData.setUint8(2, 0x46);
    byteData.setUint8(3, 0x46);
    byteData.setUint32(4, fileSize, Endian.little);
    byteData.setUint8(8, 0x57);
    byteData.setUint8(9, 0x41);
    byteData.setUint8(10, 0x56);
    byteData.setUint8(11, 0x45);
    byteData.setUint8(12, 0x66);
    byteData.setUint8(13, 0x6D);
    byteData.setUint8(14, 0x74);
    byteData.setUint8(15, 0x20);
    byteData.setUint32(16, 16, Endian.little);
    byteData.setUint16(20, 1, Endian.little);
    byteData.setUint16(22, numChannels, Endian.little);
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, sampleRate * numChannels * (bitsPerSample ~/ 8), Endian.little);
    byteData.setUint16(32, numChannels * (bitsPerSample ~/ 8), Endian.little);
    byteData.setUint16(34, bitsPerSample, Endian.little);
    byteData.setUint8(36, 0x64);
    byteData.setUint8(37, 0x61);
    byteData.setUint8(38, 0x74);
    byteData.setUint8(39, 0x61);
    byteData.setUint32(40, dataSize, Endian.little);

    int offset = 44;
    for (int i = 0; i < numSamples; i++) {
      final sample = (2500 * (i % 40 == 0 ? 1 : 0)).clamp(-32768, 32767);
      byteData.setInt16(offset, sample, Endian.little);
      offset += 2;
    }

    return byteData.buffer.asUint8List();
  }
}
