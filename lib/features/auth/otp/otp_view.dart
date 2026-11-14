import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A0F3A), Color(0xFF0B0718)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0x1AFFFFFF),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Title: Enter your OTP
                  const Text(
                    'Enter your OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle + Edit Email
                  Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.5,
                              ),
                              children: [
                                const TextSpan(text: 'Please enter the 6-digit code sent to\n'),
                                TextSpan(
                                  text: controller.email.value.isNotEmpty
                                      ? controller.email.value
                                      : 'asiva1317@gmail.com',
                                  style: const TextStyle(
                                    color: Color(0xFFFF58D6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Change Email',
                          icon: const Icon(Icons.edit_note, color: Color(0xFFFF58D6), size: 24),
                          onPressed: controller.showChangeEmailDialog,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Container Card
                  GestureDetector(
                    onTap: () {
                      controller.focusNode.requestFocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      decoration: BoxDecoration(
                        color: const Color(0x14FFFFFF),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),

                          // OTP Digit Boxes + Hidden TextField
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Visual Boxes (6 Digits)
                              Obx(() {
                                final currentPin = controller.pin.value;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(controller.pinLength, (index) {
                                    final isCurrent = currentPin.length == index;
                                    final isFilled = index < currentPin.length;
                                    final digit = isFilled ? currentPin[index] : '';

                                    return Expanded(
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: isFilled
                                              ? const Color(0x28EF3AAB)
                                              : const Color(0x18FFFFFF),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isCurrent
                                                ? const Color(0xFFEF3AAB)
                                                : isFilled
                                                    ? const Color(0x99EF3AAB)
                                                    : Colors.white24,
                                            width: isCurrent ? 2 : 1.2,
                                          ),
                                          boxShadow: isCurrent
                                              ? [
                                                  BoxShadow(
                                                    color: const Color(0xFFEF3AAB).withOpacity(0.4),
                                                    blurRadius: 12,
                                                    spreadRadius: 1,
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        child: Center(
                                          child: Text(
                                            digit.isNotEmpty ? digit : '—',
                                            style: TextStyle(
                                              color: digit.isNotEmpty
                                                  ? Colors.white
                                                  : Colors.white30,
                                              fontSize: digit.isNotEmpty ? 22 : 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }),

                              // Full coverage hidden TextField
                              Positioned.fill(
                                child: Opacity(
                                  opacity: 0.0,
                                  child: TextField(
                                    controller: controller.pinController,
                                    focusNode: controller.focusNode,
                                    keyboardType: TextInputType.number,
                                    maxLength: controller.pinLength,
                                    autofocus: true,
                                    showCursor: false,
                                    enableInteractiveSelection: true,
                                    onChanged: controller.onPinChanged,
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Verify OTP Button
                          SizedBox(
                            width: double.infinity,
                            child: Obx(
                              () => ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller.verifyOtp,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: const Color(0xFFEF3AAB),
                                ),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Verify OTP',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Resend OTP countdown
                          Obx(() {
                            final secondsLeft = controller.resendCountdown.value;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't receive the OTP?",
                                  style: TextStyle(color: Colors.white60, fontSize: 14),
                                ),
                                const SizedBox(width: 6),
                                if (secondsLeft > 0)
                                  Text(
                                    'Resend in ${secondsLeft}s',
                                    style: const TextStyle(
                                      color: Color(0xFFFF58D6),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  )
                                else
                                  TextButton(
                                    onPressed: controller.isResending.value
                                        ? null
                                        : controller.resendOtp,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: controller.isResending.value
                                        ? const SizedBox(
                                            width: 14,
                                            height: 14,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xFFEF3AAB),
                                            ),
                                          )
                                        : const Text(
                                            'Resend OTP',
                                            style: TextStyle(
                                              color: Color(0xFFEF3AAB),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                  ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Back to Login Link
                  Center(
                    child: TextButton(
                      onPressed: controller.goToLogin,
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading Overlay
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.black.withOpacity(0.6),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Color(0xFFFF58D6)),
                          SizedBox(height: 16),
                          Text(
                            'Verifying OTP...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
