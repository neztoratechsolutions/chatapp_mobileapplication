import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Header Card
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
                              controller.name.value.isNotEmpty
                                  ? controller.name.value.substring(0, 1)
                                  : 'U',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(controller.name.value,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
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

                  // Menu Items List
                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.profileMenu.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = controller.profileMenu[index];
                        final isLogout = item['isLogout'] == true || item['title'] == 'Logout';

                        return Container(
                          decoration: BoxDecoration(
                            color: isLogout
                                ? const Color(0xFF261224)
                                : const Color(0xFF17132F),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isLogout
                                  ? Colors.redAccent.withOpacity(0.3)
                                  : Colors.white10,
                            ),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isLogout
                                    ? Colors.redAccent.withOpacity(0.15)
                                    : const Color(0xFF1D1936),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: isLogout
                                    ? Colors.redAccent
                                    : const Color(0xFFFF58D6),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              item['title'] as String,
                              style: TextStyle(
                                color: isLogout ? Colors.redAccent : Colors.white,
                                fontSize: 16,
                                fontWeight: isLogout ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: isLogout
                                  ? Colors.redAccent.withOpacity(0.5)
                                  : Colors.white24,
                              size: 18,
                            ),
                            onTap: () {
                              if (isLogout) {
                                controller.confirmLogout();
                              } else if (item['title'] == 'Wallet') {
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

          // Loading Overlay
          Obx(
            () => controller.isLoggingOut.value
                ? Container(
                    color: Colors.black.withOpacity(0.65),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.redAccent,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Logging out...',
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
