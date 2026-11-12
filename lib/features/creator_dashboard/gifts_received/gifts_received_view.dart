import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'gifts_received_controller.dart';

class GiftsReceivedView extends GetView<GiftsReceivedController> {
  const GiftsReceivedView({super.key});

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
              // Header with Back Button
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Gifts Received',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 6),
              const Text(
                'Your share: 20% of every gift',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),

              // 5. 2x2 Summary Cards Grid
              Obx(() => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.card_giftcard_rounded,
                          value: '${controller.totalGifts.value}',
                          label: 'Total gifts',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.monetization_on_outlined,
                          value: '${controller.giftCoins.value}',
                          label: 'Gift coins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.trending_up_rounded,
                          value: '${controller.yourEarnings.value}',
                          label: 'Your earnings',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.emoji_events_outlined,
                          value: controller.topSupporter.value,
                          label: 'Top supporter',
                        ),
                      ),
                    ],
                  ),
                ],
              )),
              const SizedBox(height: 24),

              // 6. Gift Breakdown Chart Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF17132F),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white12, width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gift breakdown',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Chart Row
                    Obx(() {
                      final showIndex = controller.showTooltipIndex.value;
                      return SizedBox(
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(controller.breakdownItems.length, (index) {
                            final item = controller.breakdownItems[index];
                            final hasValue = item.coins > 0;
                            
                            return Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        // The Bar (or empty placeholder line)
                                        if (hasValue)
                                          FractionallySizedBox(
                                            heightFactor: item.heightFraction,
                                            alignment: Alignment.bottomCenter,
                                            child: GestureDetector(
                                              onTap: () => controller.selectBar(index),
                                              child: Container(
                                                width: 24,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFF58D6),
                                                  borderRadius: BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(0xFFFF58D6).withOpacity(0.3),
                                                      blurRadius: 6,
                                                      offset: const Offset(0, 2),
                                                    )
                                                  ]
                                                ),
                                              ),
                                            ),
                                          )
                                        else
                                          const SizedBox(
                                            width: 24,
                                            height: 1, // flat baseline for empty items
                                          ),
                                        
                                        // Dynamic Tooltip Overlay
                                        if (showIndex == index && hasValue)
                                          Positioned(
                                            bottom: (item.heightFraction * 140) / 2 + 10,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF0F0B21),
                                                borderRadius: BorderRadius.circular(14),
                                                border: Border.all(color: Colors.white10),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black45,
                                                    blurRadius: 8,
                                                    spreadRadius: 1,
                                                  )
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(item.emoji, style: const TextStyle(fontSize: 16)),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'coins : ${item.coins}',
                                                    style: const TextStyle(
                                                      color: Color(0xFFFF58D6),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Base line divider
                                  Container(
                                    height: 1.5,
                                    color: Colors.white10,
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Bottom Label Emoji
                                  GestureDetector(
                                    onTap: () => controller.selectBar(index),
                                    child: Text(
                                      item.emoji,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF17132F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF58D6),
            size: 24,
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
