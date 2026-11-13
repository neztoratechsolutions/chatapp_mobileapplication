import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'wallet_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFF58D6);
    const darkBg = Color(0xFF0F0B21);
    const cardBg = Color(0xFF1B1632);

    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
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

            // Main scrollable content
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 12),
                  // Title Header
                  const Text(
                    'Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manage your coins',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Current Balance Card
                  _buildBalanceCard(context, cardBg, accentColor),

                  const SizedBox(height: 28),

                  // Quick Packs Section Title
                  const Text(
                    'Quick packs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Packs Grid
                  Obx(() => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.coinPacks.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 18,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, index) {
                      final pack = controller.coinPacks[index];
                      return _buildPackCard(pack, cardBg, accentColor);
                    },
                  )),

                  const SizedBox(height: 28),

                  // Recent Activity Title
                  const Text(
                    'Recent activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Recent Activity List
                  Obx(() => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.transactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final tx = controller.transactions[index];
                      final isCredit = tx['isCredit'] as bool;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: darkBg,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                isCredit
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                color: isCredit ? Colors.green : Colors.redAccent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx['title'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tx['subtitle'] as String,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    _buildSingleCoin(size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      tx['amount'] as String,
                                      style: TextStyle(
                                        color: isCredit ? Colors.green : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tx['time'] as String,
                                  style: const TextStyle(
                                    color: Colors.white30,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  Widget _buildBalanceCard(BuildContext context, Color cardBg, Color accentColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF221A46),
            Color(0xFF161131),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Gold Radial Glow in top-right corner
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFB300).withOpacity(0.22),
                      const Color(0xFFFFB300).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current balance',
                    style: TextStyle(
                      color: Color(0xFF9E9DB5),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildDoubleCoin(size: 32),
                      const SizedBox(width: 14),
                      Text(
                        '${controller.balance.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    '≈ ₹${(controller.balance.value * 0.9).toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                    ),
                  )),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      // Buy Coins Button
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed('/buy-coins');
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEA4DFF), Color(0xFFFF58D6)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF58D6).withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '+ Buy Coins',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // History Button
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            Get.snackbar(
                              'History',
                              'Transaction logs are fully loaded below.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: cardBg,
                              colorText: Colors.white,
                              borderRadius: 12,
                              margin: const EdgeInsets.all(16),
                            );
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E2A44).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'History',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackCard(Map<String, dynamic> pack, Color cardBg, Color accentColor) {
    final int coins = pack['coins'] as int;
    final int price = pack['price'] as int;
    final int bonus = pack['bonus'] as int;
    final bool isPopular = pack['popular'] as bool;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            final idx = controller.coinPacks.indexOf(pack);
            if (idx != -1) {
              controller.selectedPackIndex.value = idx;
            }
            Get.toNamed('/buy-coins');
          },
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isPopular ? accentColor.withOpacity(0.6) : Colors.white.withOpacity(0.08),
                width: isPopular ? 1.5 : 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDoubleCoin(size: 24),
                const SizedBox(height: 10),
                Text(
                  coins.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},',
                      ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (bonus > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '+$bonus bonus',
                    style: const TextStyle(
                      color: Color(0xFF00E676),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 18), // Spacer to keep heights consistent
                ],
                const SizedBox(height: 8),
                Text(
                  '₹$price',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Popular Badge
        if (isPopular)
          Positioned(
            top: -8,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Popular',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDoubleCoin({double size = 24}) {
    return SizedBox(
      width: size * 1.5,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: size * 0.4,
            top: 0,
            child: _buildSingleCoin(size: size),
          ),
          Positioned(
            left: 0,
            top: size * 0.08,
            child: _buildSingleCoin(size: size),
          ),
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
        border: Border.all(color: const Color(0xFF5D4037), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1.5,
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
