import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    if (controller.notificationsList.isEmpty) return const SizedBox.shrink();
                    return TextButton(
                      onPressed: () => controller.clearAll(),
                      child: const Text(
                        'Clear all',
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 24),

              // Notifications List
              Expanded(
                child: Obx(() {
                  final list = controller.notificationsList;

                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: cardBg,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.05)),
                            ),
                            child: const Icon(
                              Icons.notifications_off_outlined,
                              color: Colors.white30,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'All caught up!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'No new notifications for you right now.',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => controller.clearNotification(index),
                        background: Container(
                          padding: const EdgeInsets.only(right: 20.0),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                            size: 24,
                          ),
                        ),
                        child: _buildNotificationCard(
                          title: item['title'] as String,
                          subtitle: item['subtitle'] as String,
                          time: item['time'] as String,
                          cardBg: cardBg,
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required String time,
    required Color cardBg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient notification badge
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF8D32F0), Color(0xFFFF58D6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF9E9DB5),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Time stamp
          Text(
            time,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
