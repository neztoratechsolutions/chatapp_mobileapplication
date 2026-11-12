import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'creator_pricing_controller.dart';

class CreatorPricingView extends GetView<CreatorPricingController> {
  const CreatorPricingView({super.key});

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
                    'Pricing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Set your per-minute coin rates',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),

              // 5. Sliders list
              Obx(() => Column(
                children: [
                  // Chat Slider Card
                  _buildSliderCard(
                    title: 'Chat',
                    value: controller.chatRate.value,
                    unit: 'coins/msg',
                    min: 2.0,
                    max: 30.0,
                    icon: Icons.chat_bubble_outline_rounded,
                    onChanged: controller.updateChatRate,
                  ),
                  const SizedBox(height: 16),

                  // Voice Call Slider Card
                  _buildSliderCard(
                    title: 'Voice Call',
                    value: controller.voiceCallRate.value,
                    unit: 'coins/min',
                    min: 10.0,
                    max: 100.0,
                    icon: Icons.phone_outlined,
                    onChanged: controller.updateVoiceCallRate,
                  ),
                  const SizedBox(height: 16),

                  // Video Call Slider Card
                  _buildSliderCard(
                    title: 'Video Call',
                    value: controller.videoCallRate.value,
                    unit: 'coins/min',
                    min: 20.0,
                    max: 200.0,
                    icon: Icons.videocam_outlined,
                    onChanged: controller.updateVideoCallRate,
                  ),
                ],
              )),
              const SizedBox(height: 32),

              // 6. Save Button
              Obx(() {
                if (controller.isSaving.value) {
                  return Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF17132F),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF58D6)),
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF58D6), Color(0xFF8D32F0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: controller.savePricing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Save pricing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSliderCard({
    required String title,
    required double value,
    required String unit,
    required double min,
    required double max,
    required IconData icon,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF17132F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFF58D6).withOpacity(0.2),
                          const Color(0xFF8D32F0).withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: const Color(0x33FF58D6), width: 1.0),
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFFFF58D6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${value.toInt()} $unit',
                style: const TextStyle(
                  color: Color(0xFFFF58D6),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: const Color(0xFFFF58D6),
              inactiveTrackColor: Colors.white12,
              thumbColor: const Color(0xFFFF58D6),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayColor: const Color(0x22FF58D6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              trackShape: const RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${min.toInt()}',
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
                Text(
                  '${max.toInt()}',
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
