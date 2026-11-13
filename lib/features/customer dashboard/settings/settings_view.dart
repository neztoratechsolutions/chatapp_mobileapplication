import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFF58D6);
    const darkBg = Color(0xFF0F0B21);
    const cardBg = Color(0xFF1B1632);

    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
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
                  const SizedBox(width: 4),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Settings Items List
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Push notifications toggle
                    Obx(() => _buildSettingToggle(
                          title: 'Push notifications',
                          value: controller.pushNotifications.value,
                          onChanged: controller.togglePushNotifications,
                          cardBg: cardBg,
                          accentColor: accentColor,
                        )),
                    const SizedBox(height: 16),

                    // Online status toggle
                    Obx(() => _buildSettingToggle(
                          title: 'Online status',
                          value: controller.onlineStatus.value,
                          onChanged: controller.toggleOnlineStatus,
                          cardBg: cardBg,
                          accentColor: accentColor,
                        )),
                    const SizedBox(height: 16),

                    // Show in search toggle
                    Obx(() => _buildSettingToggle(
                          title: 'Show in search',
                          value: controller.showInSearch.value,
                          onChanged: controller.toggleShowInSearch,
                          cardBg: cardBg,
                          accentColor: accentColor,
                        )),
                    const SizedBox(height: 16),

                    // Auto-recharge coins toggle
                    Obx(() => _buildSettingToggle(
                          title: 'Auto-recharge coins',
                          value: controller.autoRechargeCoins.value,
                          onChanged: controller.toggleAutoRechargeCoins,
                          cardBg: cardBg,
                          accentColor: accentColor,
                        )),
                    const SizedBox(height: 24),

                    // App Version info
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'App version 1.0.0 (demo)',
                        style: TextStyle(
                          color: Colors.white30,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingToggle({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color cardBg,
    required Color accentColor,
  }) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: accentColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white12,
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }
}
