import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../wallet/wallet_controller.dart';

class RewardsController extends GetxController {
  final balance = 260.obs;
  
  // Claim states for 7 days.
  // Day 1-3 are already claimed (true), Day 4 is current claimable (false), Days 5-7 are locked (false)
  final claimedDays = <int, bool>{
    1: true,
    2: true,
    3: true,
    4: false,
    5: false,
    6: false,
    7: false,
  }.obs;

  final checkInRewards = const <int, int>{
    1: 10,
    2: 20,
    3: 30,
    4: 50,
    5: 75,
    6: 100,
    7: 200,
  };

  final isTodayClaimed = false.obs;

  final referralLink = 'velora.live/ref/AARAV500';
  final friendsJoined = 3.obs;
  final coinsEarned = 1500.obs;

  final achievements = <Map<String, dynamic>>[
    {
      'title': 'First Spark',
      'desc': 'Sent your 1st gift',
      'icon': Icons.local_fire_department_outlined,
      'isUnlocked': true,
    },
    {
      'title': 'Top Supporter',
      'desc': 'Sent 10 gifts',
      'icon': Icons.emoji_events_outlined,
      'isUnlocked': true,
    },
    {
      'title': 'Coin Master',
      'desc': 'Earn 1000 coins',
      'icon': Icons.monetization_on_outlined,
      'isUnlocked': false,
    },
    {
      'title': 'Social Butterfly',
      'desc': 'Chat with 5 creators',
      'icon': Icons.chat_bubble_outline,
      'isUnlocked': false,
    },
    {
      'title': 'Lucky Winner',
      'desc': 'Win a game round',
      'icon': Icons.videogame_asset_outlined,
      'isUnlocked': false,
    },
    {
      'title': 'Loyal Fan',
      'desc': 'Check-in for 7 days',
      'icon': Icons.star_border,
      'isUnlocked': false,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Try to sync with WalletController if available
    try {
      if (Get.isRegistered<WalletController>()) {
        final walletController = Get.find<WalletController>();
        // Initialize balance with wallet controller if it has coins
        balance.value = walletController.balance.value;
      }
    } catch (_) {}
  }

  void claimToday() {
    if (isTodayClaimed.value) return;

    // Day 4 is current
    claimedDays[4] = true;
    isTodayClaimed.value = true;
    
    final rewardAmount = checkInRewards[4] ?? 50;
    balance.value += rewardAmount;

    // Also update WalletController if it exists
    try {
      if (Get.isRegistered<WalletController>()) {
        final walletController = Get.find<WalletController>();
        walletController.balance.value += rewardAmount;
        
        // Add to transaction history
        walletController.transactions.insert(0, {
          'title': 'Check-in Reward',
          'subtitle': 'Daily bonus coins (Day 4)',
          'amount': '+$rewardAmount',
          'time': 'Just now',
          'isCredit': true,
        });
      }
    } catch (_) {}

    Get.snackbar(
      'Claimed Successfully!',
      'You received $rewardAmount bonus coins!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1B1632),
      colorText: Colors.white,
      borderColor: const Color(0xFFFF58D6),
      borderWidth: 1,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
      duration: const Duration(seconds: 3),
    );
  }

  void copyReferral() {
    Clipboard.setData(ClipboardData(text: referralLink));
    
    Get.snackbar(
      'Copied!',
      'Referral link copied to clipboard.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1B1632),
      colorText: Colors.white,
      borderColor: const Color(0xFFFF58D6),
      borderWidth: 1,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.copy_all_outlined, color: Color(0xFFFF58D6), size: 24),
      duration: const Duration(seconds: 2),
    );
  }

  void showBadgeDetails(Map<String, dynamic> badge) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        decoration: const BoxDecoration(
          color: Color(0xFF17132F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border(
            top: BorderSide(color: Colors.white10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: badge['isUnlocked'] 
                      ? [const Color(0xFF9555FF), const Color(0xFFFF58D6)]
                      : [Colors.grey.shade800, Colors.grey.shade900],
                ),
              ),
              child: Icon(
                badge['icon'] as IconData,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              badge['title'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge['desc'] as String,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: badge['isUnlocked']
                    ? const Color(0x1F00E676)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    badge['isUnlocked'] ? Icons.check_circle : Icons.lock_outline,
                    color: badge['isUnlocked'] ? Colors.green : Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    badge['isUnlocked'] ? 'Badge Unlocked' : 'Locked',
                    style: TextStyle(
                      color: badge['isUnlocked'] ? Colors.green : Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
