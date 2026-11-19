import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'kyc_verify_controller.dart';

class KycVerifyView extends GetView<KycVerifyController> {
  const KycVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFFF58D6),
          backgroundColor: const Color(0xFF17132F),
          onRefresh: () => controller.fetchExistingKyc(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Back Button & Refresh
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'KYC Verification',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Obx(() {
                      if (controller.isKycLoading.value) {
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF58D6)),
                          ),
                        );
                      }
                      return IconButton(
                        onPressed: controller.fetchExistingKyc,
                        icon: const Icon(Icons.refresh, color: Colors.white70, size: 22),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress count
                Obx(
                  () => Text(
                    '${controller.completedStepsCount}/3 steps complete',
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),

                // Progress Bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Obx(() {
                      return Container(
                        width: double.infinity,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF17132F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: constraints.maxWidth * controller.progressFraction,
                              height: 8,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF58D6), Color(0xFF8D32F0)],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
                const SizedBox(height: 24),

                // 3 Verification Steps
                Obx(() => Column(
                  children: [
                    // 1. Voice Verification (/creator-verification/{creator_id})
                    _buildVoiceCard(context),
                    const SizedBox(height: 16),

                    // 2. Selfie Verification (/creator-verification/{creator_id})
                    _buildSelfieCard(context),
                    const SizedBox(height: 16),

                    // 3. Bank Document Verification (/creator-kyc/{user_id})
                    _buildBankCard(context),
                  ],
                )),

                // Completion status
                const SizedBox(height: 28),
                Obx(() {
                  if (controller.completedStepsCount == 3) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F3223),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x3300C853)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified_rounded, color: Color(0xFF00C853), size: 36),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Verification Submitted',
                                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'All 3 KYC steps completed and submitted.',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. Voice Step Card
  // ==========================================
  Widget _buildVoiceCard(BuildContext context) {
    final isDone = controller.isVoiceCompleted.value;
    final isRecording = controller.isRecording.value;
    final isUploading = controller.isVoiceUploading.value;
    final hasVoice = controller.voiceRecordUrl.value.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17132F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isRecording ? const Color(0xFFFF58D6) : (isDone ? const Color(0x3300C853) : Colors.white10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isRecording ? const Color(0x33FF58D6) : const Color(0xFF221F35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.mic_none_outlined,
                  color: isDone ? const Color(0xFF00C853) : const Color(0xFFFF58D6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Voice Verification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(
                      isRecording
                          ? 'Recording... ${controller.formattedRecordingTime}'
                          : isUploading
                              ? 'Uploading voice...'
                              : (isDone
                                  ? 'Status: ${controller.voiceStatus.value.isNotEmpty ? controller.voiceStatus.value : "Submitted"} (${controller.voiceDuration.value > 0 ? controller.voiceDuration.value : 5.2}s)'
                                  : 'Record 5s sample'),
                      style: TextStyle(
                        color: isRecording ? const Color(0xFFFF58D6) : (isDone ? const Color(0xFF00C853) : Colors.white60),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isRecording)
                ElevatedButton(
                  onPressed: controller.stopVoiceRecordingAndUpload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  ),
                  child: const Text('Stop', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                )
              else
                _buildActionPill(
                  isDone: isDone,
                  isLoading: isUploading,
                  text: 'Record',
                  icon: Icons.mic,
                  onTap: controller.startVoiceRecording,
                ),
            ],
          ),

          // Display Voice File & Status from GET API
          if (hasVoice && !isRecording) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0B21),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x3300C853)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.audio_file_rounded, color: Color(0xFF00C853), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.voiceRecordUrl.value,
                          style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (controller.voiceDuration.value > 0)
                          Text(
                            'Duration: ${controller.voiceDuration.value}s  •  Status: ${controller.voiceStatus.value.toUpperCase()}',
                            style: const TextStyle(color: Color(0xFF00C853), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.startVoiceRecording,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF221F35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('Re-record', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // 2. Selfie Step Card (Front Camera Only)
  // ==========================================
  Widget _buildSelfieCard(BuildContext context) {
    final isDone = controller.isSelfieCompleted.value;
    final isUploading = controller.isSelfieUploading.value;
    final hasImage = controller.selfiePhotoUrl.value.isNotEmpty || controller.selectedSelfieImage.value != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17132F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDone ? const Color(0x3300C853) : Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF221F35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.photo_camera_front_outlined,
                  color: isDone ? const Color(0xFF00C853) : const Color(0xFFFF58D6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selfie Verification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(
                      isUploading
                          ? 'Uploading selfie...'
                          : (isDone
                              ? 'Status: ${controller.selfieStatus.value.isNotEmpty ? controller.selfieStatus.value : "Submitted"}'
                              : 'Front camera only'),
                      style: TextStyle(
                        color: isDone ? const Color(0xFF00C853) : Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionPill(
                isDone: isDone,
                isLoading: isUploading,
                text: 'Capture',
                icon: Icons.camera_front,
                onTap: controller.captureSelfieFromFrontCamera,
              ),
            ],
          ),
          if (hasImage) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: 140,
                child: _buildPreviewImage(
                  localFile: controller.selectedSelfieImage.value,
                  networkUrl: controller.fullSelfiePhotoUrl,
                ),
              ),
            ),
            if (controller.selfiePhotoUrl.value.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                controller.selfiePhotoUrl.value,
                style: const TextStyle(color: Colors.white38, fontSize: 10, fontFamily: 'monospace'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ==========================================
  // 3. Bank Step Card
  // ==========================================
  Widget _buildBankCard(BuildContext context) {
    final isDone = controller.isBankCompleted.value;
    final isUploading = controller.isBankUploading.value;
    final hasImage = controller.bankPhotoUrl.value.isNotEmpty || controller.selectedBankImage.value != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17132F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDone ? const Color(0x3300C853) : Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF221F35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.credit_card_outlined,
                  color: isDone ? const Color(0xFF00C853) : const Color(0xFFFF58D6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bank Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(
                      isUploading ? 'Uploading bank photo...' : (isDone ? 'Bank image verified' : 'Upload passbook or cheque'),
                      style: TextStyle(
                        color: isDone ? const Color(0xFF00C853) : Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionPill(
                isDone: isDone,
                isLoading: isUploading,
                text: 'Upload',
                icon: Icons.upload_file,
                onTap: controller.showBankImagePicker,
              ),
            ],
          ),
          if (hasImage) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: 140,
                child: _buildPreviewImage(
                  localFile: controller.selectedBankImage.value,
                  networkUrl: controller.fullBankPhotoUrl,
                ),
              ),
            ),
            if (controller.bankPhotoUrl.value.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                controller.bankPhotoUrl.value,
                style: const TextStyle(color: Colors.white38, fontSize: 10, fontFamily: 'monospace'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ],
      ),
    );
  }

  // Reusable Image Preview
  Widget _buildPreviewImage({File? localFile, required String networkUrl}) {
    if (localFile != null) {
      return Image.file(localFile, fit: BoxFit.cover);
    }
    if (networkUrl.isNotEmpty) {
      return Image.network(
        networkUrl,
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF58D6))),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFF221F35),
          child: const Center(child: Icon(Icons.broken_image, color: Colors.white38)),
        ),
      );
    }
    return Container(color: const Color(0xFF221F35));
  }

  // Custom Action Pill Button
  Widget _buildActionPill({
    required bool isDone,
    required bool isLoading,
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    if (isDone) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0F3223),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x3300C853)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF00C853), size: 14),
              SizedBox(width: 4),
              Text('Done', style: TextStyle(color: Color(0xFF00C853), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }

    if (isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: const Color(0xFF221F35), borderRadius: BorderRadius.circular(16)),
        child: const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF58D6))),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(colors: [Color(0xFFFF58D6), Color(0xFF8D32F0)]),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 13),
            const SizedBox(width: 4),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
