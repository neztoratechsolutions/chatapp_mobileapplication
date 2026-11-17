import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'creator_dashboard_controller.dart';

class CreatorDashboardView extends GetView<CreatorDashboardController> {
  const CreatorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
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
                          onPressed: controller.confirmLogout,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 2. Online status switch (connected to API http://62.72.31.253:8002/user-status/)
                    Obx(
                      () => GestureDetector(
                        onTap: controller.isUpdatingStatus.value
                            ? null
                            : controller.toggleOnlineStatus,
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
                                  if (controller.isUpdatingStatus.value)
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFFF58D6),
                                      ),
                                    )
                                  else
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
                              Row(
                                children: [
                                  Text(
                                    controller.isOnline.value ? 'Available' : 'Unavailable',
                                    style: TextStyle(
                                      color: controller.isOnline.value
                                          ? const Color(0xFF00C853).withOpacity(0.8)
                                          : Colors.white38,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: controller.isOnline.value
                                          ? const Color(0xFF00C853)
                                          : Colors.white24,
                                      boxShadow: controller.isOnline.value
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF00C853).withOpacity(0.6),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              )
                                            ]
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Horizontal Tab Navigation Bar
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(
                        () => Row(
                          children: [
                            _buildTabItem('Dashboard', Icons.grid_view_rounded),
                            const SizedBox(width: 10),
                            _buildTabItem('Inbox', Icons.chat_bubble_outline_rounded),
                            const SizedBox(width: 10),
                            _buildTabItem('Reviews', Icons.star_outline_rounded),
                            const SizedBox(width: 10),
                            _buildTabItem('Earnings', Icons.bar_chart_rounded),
                            const SizedBox(width: 10),
                            _buildTabItem('Pricing', Icons.account_balance_wallet_outlined),
                            const SizedBox(width: 10),
                            _buildTabItem('Gallery', Icons.image_outlined),
                            const SizedBox(width: 10),
                            _buildTabItem('KYC', Icons.verified_user_outlined),
                            const SizedBox(width: 10),
                            _buildTabItem('Profile Setup', Icons.person_outline_rounded),
                            const SizedBox(width: 10),
                            _buildTabItem('Gifts', Icons.card_giftcard_rounded),
                            const SizedBox(width: 10),
                            _buildTabItem('Logout', Icons.logout_rounded),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 4. Main Body Content Switcher
                    Obx(() {
                      switch (controller.selectedTab.value) {
                        case 'Dashboard':
                          return _buildDashboardContent();
                        case 'Inbox':
                          return _buildInboxContent();
                        case 'Reviews':
                          return _buildReviewsContent();
                        default:
                          return _buildDashboardContent();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
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
          color: isSelected ? null : const Color(0xFF17132F),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white10,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF58D6).withOpacity(0.35),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white60,
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

  // Dashboard Tab Content (Overview, Stats, KYC Banner, Tools)
  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Header
        Obx(
          () => RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 28, fontFamily: 'Roboto'),
              children: [
                const TextSpan(
                  text: 'Hi, ',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: '${controller.creatorName.value} ',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: '👋',
                  style: TextStyle(fontSize: 26),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Here's how you're doing today",
          style: TextStyle(color: Colors.white60, fontSize: 15),
        ),
        const SizedBox(height: 20),

        // Complete KYC warning block
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF17132F),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0x33FFB300), width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFFFB300),
                size: 26,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Complete your KYC',
                      style: TextStyle(
                        color: Color(0xFFFFB300),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "You can't receive payouts until verified.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => controller.navigateToTool('/kyc-verify'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB300),
                  foregroundColor: const Color(0xFF0F0B21),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Verify', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2x2 Stats Grid
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: "Today's earnings",
                value: controller.todayEarnings.value,
                icon: Icons.trending_up_rounded,
                iconColor: const Color(0xFF00C853),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                label: 'Followers',
                value: controller.followersCount.value,
                icon: Icons.people_outline_rounded,
                iconColor: const Color(0xFFFF58D6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'Calls',
                value: controller.callsCount.value,
                icon: Icons.phone_outlined,
                iconColor: const Color(0xFF8D32F0),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                label: 'Rating',
                value: controller.ratingValue.value,
                icon: Icons.star_outline_rounded,
                iconColor: const Color(0xFFFFD600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Weekly Earnings Row Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF17132F),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly earnings',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD600),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Obx(
                  () => Text(
                    controller.weeklyEarnings.value,
                    style: const TextStyle(
                      color: Color(0xFF0F0B21),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Creator Tools Section
        const Text(
          'Creator Tools',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: [
            _buildToolTile(
              title: 'Earnings',
              subtitle: 'View analytics',
              icon: Icons.bar_chart_rounded,
              color: const Color(0xFF00C853),
              routeName: '/creator-earnings',
            ),
            _buildToolTile(
              title: 'Pricing',
              subtitle: 'Set call rates',
              icon: Icons.account_balance_wallet_outlined,
              color: const Color(0xFFFFD600),
              routeName: '/creator-pricing',
            ),
            _buildToolTile(
              title: 'Gallery',
              subtitle: 'Photos & videos',
              icon: Icons.image_outlined,
              color: const Color(0xFFFF58D6),
              routeName: '/creator-gallery',
            ),
            _buildToolTile(
              title: 'Gifts',
              subtitle: 'Gifts received',
              icon: Icons.card_giftcard_rounded,
              color: const Color(0xFF8D32F0),
              routeName: '/gifts-received',
            ),
            _buildToolTile(
              title: 'Profile Setup',
              subtitle: 'Edit details',
              icon: Icons.person_outline_rounded,
              color: const Color(0xFF00B0FF),
              routeName: '/profile-setup',
            ),
            _buildToolTile(
              title: 'KYC Verify',
              subtitle: 'Identity status',
              icon: Icons.verified_user_outlined,
              color: const Color(0xFFFF9100),
              routeName: '/kyc-verify',
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Quick Reviews Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Reviews',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => controller.changeTab('Reviews'),
              child: const Text('View All', style: TextStyle(color: Color(0xFFFF58D6))),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.reviews.take(2).length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final review = controller.reviews[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF17132F).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review['name'],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          review['time'],
                          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(5, (sIndex) {
                        return Icon(
                          Icons.star_rounded,
                          color: sIndex < review['rating'] ? const Color(0xFFFFB300) : Colors.white10,
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review['comment'],
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _buildToolTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String routeName,
  }) {
    return GestureDetector(
      onTap: () => controller.navigateToTool(routeName),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF17132F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // Inbox Tab Content (Customer Conversations)
  Widget _buildInboxContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inbox',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
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
                    color: const Color(0xFF120F26).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey.shade900,
                            backgroundImage: NetworkImage(convo['avatar']),
                          ),
                          if (convo['online'] == true)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C853),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF0F0B21), width: 2),
                                ),
                              ),
                            ),
                        ],
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
    );
  }

  // Reviews Tab Content
  Widget _buildReviewsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'What customers say',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 24),
        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final review = controller.reviews[index];
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF17132F).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          review['time'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          Icons.star_rounded,
                          color: starIndex < review['rating']
                              ? const Color(0xFFFFB300)
                              : Colors.white10,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      review['comment'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF17132F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
