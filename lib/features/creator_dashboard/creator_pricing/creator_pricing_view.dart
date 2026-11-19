import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'creator_pricing_controller.dart';

class CreatorPricingView extends GetView<CreatorPricingController> {
  const CreatorPricingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0B21),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        title: const Text(
          'Pricing Rates',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.hasExistingPricing.value) {
              return IconButton(
                onPressed: () => _showDeleteConfirmation(context),
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 24),
                tooltip: 'Delete Pricing',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFFF58D6),
          backgroundColor: const Color(0xFF17132F),
          onRefresh: controller.fetchPricingDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top trending overview card
                _buildOverviewHeader(),
                const SizedBox(height: 24),

                // 1. Chat Pricing Card
                Obx(() => _buildPricingCard(
                  title: 'Chat Rate',
                  subtitle: 'Per direct message sent by user',
                  unit: 'coins/msg',
                  currentValue: controller.chatRate.value,
                  textController: controller.chatController,
                  sliderMin: 0.0,
                  sliderMax: 500.0,
                  quickPresets: [20, 50, 100, 200],
                  primaryColor: const Color(0xFFFF58D6),
                  icon: Icons.chat_bubble_rounded,
                  onSliderChanged: controller.setChatRate,
                  onTextChanged: controller.onChatTextChanged,
                )),
                const SizedBox(height: 18),

                // 2. Voice Call Pricing Card
                Obx(() => _buildPricingCard(
                  title: 'Voice Call',
                  subtitle: 'Per minute audio call rate',
                  unit: 'coins/min',
                  currentValue: controller.voiceCallRate.value,
                  textController: controller.voiceController,
                  sliderMin: 0.0,
                  sliderMax: 2000.0,
                  quickPresets: [100, 300, 500, 1000],
                  primaryColor: const Color(0xFF00C8FF),
                  icon: Icons.phone_in_talk_rounded,
                  onSliderChanged: controller.setVoiceRate,
                  onTextChanged: controller.onVoiceTextChanged,
                )),
                const SizedBox(height: 18),

                // 3. Video Call Pricing Card
                Obx(() => _buildPricingCard(
                  title: 'Video Call',
                  subtitle: 'Per minute HD video call rate',
                  unit: 'coins/min',
                  currentValue: controller.videoCallRate.value,
                  textController: controller.videoController,
                  sliderMin: 0.0,
                  sliderMax: 5000.0,
                  quickPresets: [500, 1000, 2000, 3000],
                  primaryColor: const Color(0xFF8D32F0),
                  icon: Icons.videocam_rounded,
                  onSliderChanged: controller.setVideoRate,
                  onTextChanged: controller.onVideoTextChanged,
                )),
                const SizedBox(height: 32),

                // Save / Update Button
                _buildSaveButton(),
                const SizedBox(height: 16),

                // Delete Pricing Option if existing
                Obx(() {
                  if (controller.hasExistingPricing.value) {
                    return Center(
                      child: TextButton.icon(
                        onPressed: () => _showDeleteConfirmation(context),
                        icon: const Icon(Icons.delete_outline, color: Colors.white54, size: 20),
                        label: const Text(
                          'Reset / Delete Current Rates',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header card with active rate badge and user id
  Widget _buildOverviewHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF17132F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF58D6), Color(0xFF8D32F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF58D6).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.monetization_on_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Set Your Coin Rates',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                  controller.hasExistingPricing.value
                      ? 'Live rates configured (ID: ${controller.pricingId.value})'
                      : 'Set coin prices to start earning from calls & chat',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                )),
              ],
            ),
          ),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: controller.hasExistingPricing.value
                  ? const Color(0xFF0F3223)
                  : const Color(0xFF261D42),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: controller.hasExistingPricing.value
                    ? const Color(0xFF00C853).withOpacity(0.5)
                    : Colors.white12,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.hasExistingPricing.value
                        ? const Color(0xFF00C853)
                        : Colors.orangeAccent,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  controller.hasExistingPricing.value ? 'Active' : 'Unset',
                  style: TextStyle(
                    color: controller.hasExistingPricing.value
                        ? const Color(0xFF00C853)
                        : Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // Modern Pricing Card with editable input, slider and preset pills
  Widget _buildPricingCard({
    required String title,
    required String subtitle,
    required String unit,
    required double currentValue,
    required TextEditingController textController,
    required double sliderMin,
    required double sliderMax,
    required List<int> quickPresets,
    required Color primaryColor,
    required IconData icon,
    required ValueChanged<double> onSliderChanged,
    required ValueChanged<String> onTextChanged,
  }) {
    final double safeSliderVal = currentValue.clamp(sliderMin, sliderMax);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF17132F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Title + Direct Input field
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.15),
                  border: Border.all(color: primaryColor.withOpacity(0.4)),
                ),
                child: Icon(icon, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Direct editable rate field
              Container(
                width: 95,
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0B21),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryColor.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: onTextChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Quick preset chips
          Row(
            children: [
              const Text(
                'Quick Set:',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: quickPresets.map((preset) {
                    final isSelected = currentValue.toInt() == preset;
                    return GestureDetector(
                      onTap: () => onSliderChanged(preset.toDouble()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : const Color(0xFF0F0B21),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? primaryColor : Colors.white12,
                          ),
                        ),
                        child: Text(
                          '$preset',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Slider Theme & Control
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: primaryColor,
              inactiveTrackColor: Colors.white12,
              thumbColor: primaryColor,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
              overlayColor: primaryColor.withOpacity(0.2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              trackShape: const RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              value: safeSliderVal,
              min: sliderMin,
              max: sliderMax,
              onChanged: onSliderChanged,
            ),
          ),

          // Min & Max bounds display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${sliderMin.toInt()} coins',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
                Text(
                  '${currentValue.toInt()} $unit',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${sliderMax.toInt()}+ coins',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Save / Update Gradient Button
  Widget _buildSaveButton() {
    return Obx(() {
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
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF58D6).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
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
            child: Text(
              controller.hasExistingPricing.value ? 'Update Pricing' : 'Save Pricing',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }

  // Confirmation dialog before deleting
  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF17132F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withOpacity(0.15),
                ),
                child: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 32),
              ),
              const SizedBox(height: 18),
              const Text(
                'Delete Pricing Rates?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to remove your saved coin rates? This will reset rates on your profile.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.deletePricing();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
