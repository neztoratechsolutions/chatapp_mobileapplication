import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'rewards_controller.dart';

class RewardsView extends GetView<RewardsController> {
  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFF58D6);
    const darkBg = Color(0xFF0F0B21);
    const cardBg = Color(0xFF17132F);

    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar (consistent with other views)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF8D32F0), Color(0xFFFF58D6)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Velora',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    'Live',
                    style: TextStyle(
                      color: Color(0xFFFF58D6),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search_outlined, color: Colors.white70, size: 22),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.card_giftcard_outlined, color: Colors.white70, size: 22),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => Get.toNamed('/notifications'),
                        icon: const Icon(Icons.notifications_none, color: Colors.white70, size: 22),
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  // Coin Balance Pill
                  Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6F00).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildSingleCoin(size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${controller.balance.value}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(width: 8),
                ],
              ),
            ),

            // Main Scrollable Content
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 12),

                  // 1. Daily Check-In Card
                  Obx(() => Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white12),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Color(0xFFFF58D6),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Daily Check-In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Days list (row of 7 day elements)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final double spacing = 6.0;
                            final double totalSpacing = spacing * 6;
                            final double itemWidth = (constraints.maxWidth - totalSpacing) / 7;
                            
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(7, (index) {
                                final int dayNum = index + 1;
                                final int rewardCoins = controller.checkInRewards[dayNum] ?? 10;
                                final bool isClaimed = controller.claimedDays[dayNum] ?? false;
                                // Day 4 is current day in the mock design
                                final bool isCurrent = dayNum == 4;
                                
                                return _buildDayPill(
                                  dayNum: dayNum,
                                  coins: rewardCoins,
                                  isClaimed: isClaimed,
                                  isCurrent: isCurrent,
                                  width: itemWidth,
                                );
                              }),
                            );
                          },
                        ),
                        const SizedBox(height: 22),

                        // Claim Button
                        InkWell(
                          onTap: controller.isTodayClaimed.value ? null : () => controller.claimToday(),
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            height: 48,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: controller.isTodayClaimed.value
                                    ? [const Color(0xFFEA4DFF).withOpacity(0.6), const Color(0xFFFF58D6).withOpacity(0.6)]
                                    : [const Color(0xFFEA4DFF), const Color(0xFFFF58D6)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: controller.isTodayClaimed.value
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: const Color(0xFFFF58D6).withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.isTodayClaimed.value ? 'Claimed ✓' : 'Claim Reward',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 18),

                  // 2. Referral Program Card
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white12),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            const Icon(
                              Icons.people_outline,
                              color: Color(0xFFFF58D6),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Referral Program',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Get 500 coins for each friend who joins.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Referral URL bar with Copy button inside
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F0B21),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  controller.referralLink,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => controller.copyReferral(),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFEA4DFF), Color(0xFFFF58D6)],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    'Copy',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Stats Footer
                        Row(
                          children: [
                            const Icon(Icons.link_outlined, color: Colors.white38, size: 18),
                            const SizedBox(width: 8),
                            Obx(() => Text(
                              '${controller.friendsJoined.value} friends joined · ${controller.coinsEarned.value} coins earned',
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 3. Achievement Badges section
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events_outlined,
                        color: Color(0xFFFF58D6),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Achievement Badges',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Badges grid
                  Obx(() => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.achievements.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, index) {
                      final badge = controller.achievements[index];
                      final bool isUnlocked = badge['isUnlocked'] as bool;
                      
                      return InkWell(
                        onTap: () => controller.showBadgeDetails(badge),
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isUnlocked ? Colors.white12 : Colors.white.withOpacity(0.05),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Badge circular icon
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: isUnlocked
                                        ? [const Color(0xFF9555FF), const Color(0xFFFF58D6)]
                                        : [Colors.grey.shade800, Colors.grey.shade900],
                                  ),
                                  boxShadow: isUnlocked
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFFFF58D6).withOpacity(0.2),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Icon(
                                  badge['icon'] as IconData,
                                  color: isUnlocked ? Colors.white : Colors.white24,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                badge['title'] as String,
                                style: TextStyle(
                                  color: isUnlocked ? Colors.white : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                badge['desc'] as String,
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Day pill matching reference mock-up
  Widget _buildDayPill({
    required int dayNum,
    required int coins,
    required bool isClaimed,
    required bool isCurrent,
    required double width,
  }) {
    // Styling colors based on status
    final Color textColor = isCurrent
        ? Colors.white
        : (isClaimed ? const Color(0xFF00E676) : Colors.white70);
    
    final Color dayLabelColor = isCurrent
        ? Colors.white.withOpacity(0.8)
        : (isClaimed ? const Color(0x9900E676) : Colors.white30);

    return Container(
      width: width,
      height: 84,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: isCurrent
            ? const LinearGradient(
                colors: [Color(0xFF9555FF), Color(0xFFFF58D6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        color: isCurrent
            ? null
            : (isClaimed 
                ? const Color(0x1F00E676) // transparent green
                : const Color(0xFF1D1936).withOpacity(0.4)),
        border: Border.all(
          color: isCurrent
              ? Colors.transparent
              : (isClaimed 
                  ? const Color(0x3300E676)
                  : Colors.white.withOpacity(0.08)),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Day\n$dayNum',
            style: TextStyle(
              color: dayLabelColor,
              fontSize: 10,
              height: 1.1,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '$coins',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Checked indicator or space
          if (isClaimed)
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF00E676),
              size: 12,
            )
          else if (isCurrent)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSingleCoin({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD54F),
            Color(0xFFFFB300),
          ],
        ),
        border: Border.all(color: const Color(0xFF5D4037), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '1',
          style: TextStyle(
            color: const Color(0xFF5D4037),
            fontWeight: FontWeight.w900,
            fontSize: size * 0.45,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
