import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inbox_controller.dart';

class InboxView extends GetView<InboxController> {
  const InboxView({super.key});

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
              // 1. Header (Logo, App Name, Logout)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF58D6), Color(0xFF8D32F0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            TextSpan(text: 'Velora', style: TextStyle(color: Colors.white)),
                            TextSpan(text: 'Creator', style: TextStyle(color: Color(0xFFFF58D6))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Logout',
                        titleStyle: const TextStyle(color: Colors.white),
                        middleText: 'Are you sure you want to logout?',
                        middleTextStyle: const TextStyle(color: Colors.white70),
                        backgroundColor: const Color(0xFF17132F),
                        textConfirm: 'Yes',
                        textCancel: 'No',
                        confirmTextColor: Colors.white,
                        cancelTextColor: Colors.white70,
                        buttonColor: const Color(0xFFFF58D6),
                        onConfirm: () {
                          Get.back();
                          Get.offAllNamed('/login');
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Online status switch
              Obx(
                () => GestureDetector(
                  onTap: controller.toggleOnlineStatus,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: controller.isOnline.value
                          ? const Color(0xFF0F3223)
                          : const Color(0xFF221F35),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: controller.isOnline.value
                            ? const Color(0x3300C853)
                            : Colors.white12,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.power_settings_new_rounded,
                              color: controller.isOnline.value
                                  ? const Color(0xFF00C853)
                                  : Colors.white54,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              controller.isOnline.value ? 'Online' : 'Offline',
                              style: TextStyle(
                                color: controller.isOnline.value
                                    ? const Color(0xFF00C853)
                                    : Colors.white54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.isOnline.value
                                ? const Color(0xFF00C853)
                                : Colors.white24,
                            boxShadow: controller.isOnline.value
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF00C853).withOpacity(0.5),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Horizontal Tab Navigation
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(
                  () => Row(
                    children: [
                      _buildTabItem('Dashboard', Icons.grid_view_rounded),
                      const SizedBox(width: 12),
                      _buildTabItem('Profile Setup', Icons.person_outline_rounded),
                      const SizedBox(width: 12),
                      _buildTabItem('KYC', Icons.verified_user_outlined),
                      const SizedBox(width: 12),
                      _buildTabItem('Gallery', Icons.image_outlined),
                      const SizedBox(width: 12),
                      _buildTabItem('Pricing', Icons.account_balance_wallet_outlined),
                      const SizedBox(width: 12),
                      _buildTabItem('Earnings', Icons.bar_chart_rounded),
                      const SizedBox(width: 12),
                      _buildTabItem('Gifts', Icons.card_giftcard_rounded),
                      const SizedBox(width: 12),
                      _buildTabItem('Inbox', Icons.chat_bubble_outline_rounded),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // 4. Section Title
              const Text(
                'Inbox',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Customer conversations',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),

              // 5. Conversations list matching mockup
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.conversations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final convo = controller.conversations[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/chat-detail', arguments: {
                          'name': convo['name'] ?? '',
                          'image': convo['avatar'] ?? '',
                          'chat': '5 coins/min',
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF120F26).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey.shade900,
                              backgroundImage: NetworkImage(convo['avatar']),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    convo['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    convo['message'],
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  convo['time'],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Display unread badge if any
                                if (convo['unread'] > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF58D6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${convo['unread']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                else
                                  const SizedBox(height: 20),
                              ],
                            ),
                          ],
                        ),
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

  Widget _buildTabItem(String tabName, IconData icon) {
    final isSelected = controller.selectedTab.value == tabName;
    return GestureDetector(
      onTap: () => controller.changeTab(tabName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFF58D6), Color(0xFF8D32F0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          border: isSelected ? null : Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              tabName,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
