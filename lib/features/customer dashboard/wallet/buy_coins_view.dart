import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'wallet_controller.dart';

class BuyCoinsView extends GetView<WalletController> {
  const BuyCoinsView({super.key});

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
            // Top App Bar (consistent with Wallet page)
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

            // Scrollable Content
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 12),
                  // Header Title
                  const Text(
                    'Buy Coins',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose a pack',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pack List Rows
                  Obx(() => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.coinPacks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final pack = controller.coinPacks[index];
                      final isSelected = controller.selectedPackIndex.value == index;
                      return _buildPackRow(pack, index, isSelected, cardBg, accentColor);
                    },
                  )),

                  const SizedBox(height: 28),

                  // Pay via Header
                  const Text(
                    'Pay via',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Options Grid
                  Obx(() => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.paymentMethods.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 3.2,
                    ),
                    itemBuilder: (context, index) {
                      final method = controller.paymentMethods[index];
                      final isSelected = controller.selectedPaymentMethod.value == method;
                      return InkWell(
                        onTap: () => controller.selectedPaymentMethod.value = method,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? accentColor : Colors.white.withOpacity(0.08),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              method,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Bottom Pay Button Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: darkBg,
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1.0),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Obx(() {
                  final selectedPack = controller.coinPacks[controller.selectedPackIndex.value];
                  final price = selectedPack['price'] as int;

                  return InkWell(
                    onTap: () => controller.paySelectedPack(),
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEA4DFF), Color(0xFFFF58D6)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF58D6).withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Pay ₹$price',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackRow(
    Map<String, dynamic> pack,
    int index,
    bool isSelected,
    Color cardBg,
    Color accentColor,
  ) {
    final int coins = pack['coins'] as int;
    final int price = pack['price'] as int;
    final int bonus = pack['bonus'] as int;
    final bool isPopular = pack['popular'] as bool;
    final bool isBestValue = pack['bestValue'] ?? false;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Card Body
        GestureDetector(
          onTap: () => controller.selectedPackIndex.value = index,
          child: Container(
            height: 76,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? accentColor : Colors.white.withOpacity(0.08),
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              children: [
                // Selection Circle Checkmark if selected
                if (isSelected) ...[
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF58D6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // Double Coin Widget
                _buildDoubleCoin(size: 24),
                const SizedBox(width: 14),

                // Pack Name & Bonus Info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${coins.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")} coins',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (bonus > 0) ...[
                        const SizedBox(height: 2),
                        Text(
                          '+$bonus bonus',
                          style: const TextStyle(
                            color: Color(0xFF00E676),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Price tag
                Text(
                  '₹$price',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Badges
        if (isPopular)
          Positioned(
            top: -8,
            right: 16,
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
                'Most popular',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        if (isBestValue)
          Positioned(
            top: -8,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB300),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB300).withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Best value',
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
