import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF17132F),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white12),
                ),
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9555FF), Color(0xFFFF58D6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          controller.name.value.substring(0, 1),
                          style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(controller.name.value,
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
                          const SizedBox(height: 6),
                          Obx(() => Text(controller.email.value,
                              style: const TextStyle(color: Colors.white70, fontSize: 14))),
                          const SizedBox(height: 8),
                          Obx(() => Text('${controller.phone.value} · ${controller.location.value}',
                              style: const TextStyle(color: Colors.white54, fontSize: 13))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.profileMenu.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = controller.profileMenu[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF17132F),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D1936),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(item['icon'] as IconData, color: const Color(0xFFFF58D6), size: 22),
                        ),
                        title: Text(item['title'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 18),
                        onTap: () {
                          if (item['title'] == 'Wallet') {
                            Get.toNamed('/wallet');
                          } else if (item['title'] == 'Settings') {
                            Get.toNamed('/settings');
                          } else if (item['title'] == 'Notifications') {
                            Get.toNamed('/notifications');
                          } else if (item['title'] == 'Rewards & Check-in') {
                            Get.toNamed('/rewards');
                          } else if (item['title'] == 'Favorite Creators') {
                            Get.toNamed('/favorites');
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
