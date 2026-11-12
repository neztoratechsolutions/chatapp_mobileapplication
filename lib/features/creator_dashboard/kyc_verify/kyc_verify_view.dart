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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Back Button
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Progress subtitle
              Obx(
                () => Text(
                  '${controller.completedStepsCount}/3 steps complete',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Progress Bar
              LayoutBuilder(
                builder: (context, constraints) {
                  return Obx(() {
                    final double maxWidth = constraints.maxWidth;
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
                            width: maxWidth * controller.progressFraction,
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
              const SizedBox(height: 32),

              // 5. Verification Tasks List
              Obx(() => Column(
                children: [
                  // Voice Verification Step
                  _buildStepCard(
                    icon: controller.isVoiceCompleted.value
                        ? Icons.check_circle_rounded
                        : Icons.mic_none_outlined,
                    iconColor: controller.isVoiceCompleted.value
                        ? const Color(0xFF00C853)
                        : const Color(0xFFFF58D6),
                    title: 'Voice Verification',
                    subtitle: controller.isRecording.value
                        ? 'Recording... ${controller.recordingSeconds.value}s remaining'
                        : controller.isVoiceCompleted.value
                            ? 'Voice sample verified'
                            : 'Record a 5s voice sample to verify your identity',
                    subtitleColor: controller.isRecording.value
                        ? const Color(0xFFFF58D6)
                        : Colors.white60,
                    actionWidget: _buildStepButton(
                      isCompleted: controller.isVoiceCompleted.value,
                      isLoading: controller.isRecording.value,
                      actionText: 'Record',
                      icon: Icons.mic_rounded,
                      onTap: controller.startVoiceRecording,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Selfie Verification Step
                  _buildStepCard(
                    icon: controller.isSelfieCompleted.value
                        ? Icons.check_circle_rounded
                        : Icons.photo_camera_outlined,
                    iconColor: controller.isSelfieCompleted.value
                        ? const Color(0xFF00C853)
                        : const Color(0xFFFF58D6),
                    title: 'Selfie Verification',
                    subtitle: controller.isSelfieUploading.value
                        ? 'Uploading face capture...'
                        : controller.isSelfieCompleted.value
                            ? 'Selfie verified successfully'
                            : 'Real-time face capture',
                    subtitleColor: controller.isSelfieUploading.value
                        ? const Color(0xFFFF58D6)
                        : Colors.white60,
                    actionWidget: _buildStepButton(
                      isCompleted: controller.isSelfieCompleted.value,
                      isLoading: controller.isSelfieUploading.value,
                      actionText: 'Upload',
                      icon: Icons.file_upload_outlined,
                      onTap: controller.startSelfieVerification,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bank Details Step
                  _buildStepCard(
                    icon: controller.isBankCompleted.value
                        ? Icons.check_circle_rounded
                        : Icons.credit_card_outlined,
                    iconColor: controller.isBankCompleted.value
                        ? const Color(0xFF00C853)
                        : const Color(0xFFFF58D6),
                    title: 'Bank Details',
                    subtitle: controller.isBankCompleted.value
                        ? 'Linked Account: ${_maskAccountNumber(controller.accountNumber.value)}'
                        : 'Account no. & IFSC',
                    subtitleColor: Colors.white60,
                    actionWidget: _buildStepButton(
                      isCompleted: controller.isBankCompleted.value,
                      isLoading: false,
                      actionText: 'Upload',
                      icon: Icons.file_upload_outlined,
                      onTap: () => _showBankDetailsDialog(context),
                    ),
                  ),
                ],
              )),

              // Success Status card when 100% complete
              const SizedBox(height: 32),
              Obx(() {
                if (controller.completedStepsCount == 3) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3223),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0x3300C853), width: 1.5),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.verified_rounded, color: Color(0xFF00C853), size: 40),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Verification Submitted',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'We are reviewing your details. This usually takes less than 24 hours.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
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
    );
  }

  // Reusable Step Row Item
  Widget _buildStepCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color subtitleColor,
    required Widget actionWidget,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF17132F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          // Step Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF221F35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),

          // Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Action
          actionWidget,
        ],
      ),
    );
  }

  // Custom pill action button
  Widget _buildStepButton({
    required bool isCompleted,
    required bool isLoading,
    required String actionText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0F3223),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x3300C853)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle_rounded, color: Color(0xFF00C853), size: 16),
            SizedBox(width: 6),
            Text(
              'Done',
              style: TextStyle(
                color: Color(0xFF00C853),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF221F35),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF58D6)),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Wait...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF58D6), Color(0xFF8D32F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(
              actionText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mask bank account number
  String _maskAccountNumber(String acc) {
    if (acc.length <= 4) return acc;
    return '•••• •••• ${acc.substring(acc.length - 4)}';
  }

  // Show bank details input dialog
  void _showBankDetailsDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF17132F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bank Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white60),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Account Number',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.accountNumberController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF0F0B21),
                  hintText: 'Enter Account Number',
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'IFSC Code',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.ifscController,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF0F0B21),
                  hintText: 'Enter IFSC Code',
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    controller.saveBankDetails();
                    if (controller.isBankCompleted.value) {
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF58D6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Save Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
