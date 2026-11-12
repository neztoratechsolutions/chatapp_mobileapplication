import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'creator_earnings_controller.dart';

class CreatorEarningsView extends GetView<CreatorEarningsController> {
  const CreatorEarningsView({super.key});

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
                    'Earnings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),

              // 5. Dual Stats Cards
              Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      label: 'Total earned',
                      value: '₹${controller.totalEarned.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      valueColor: const Color(0xFFFF58D6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      label: 'Available payout',
                      value: '₹${controller.availablePayout.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      valueColor: Colors.white,
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 24),

              // 6. Last 7 Days Chart Card
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
                      'Last 7 days',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Chart Area
                    SizedBox(
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: controller.dailyEarnings.map((item) {
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Animated/Static Bar Container
                                Expanded(
                                  child: FractionallySizedBox(
                                    heightFactor: item.value,
                                    alignment: Alignment.bottomCenter,
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
                                ),
                                const SizedBox(height: 8),
                                
                                // Divider base line (conceptually separating bars and text)
                                Container(
                                  height: 1.5,
                                  color: Colors.white10,
                                ),
                                const SizedBox(height: 8),
                                
                                // Day Label
                                Text(
                                  item.day,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 7. Withdraw Button
              Obx(() {
                final isAvailable = controller.availablePayout.value > 0;
                final buttonText = isAvailable
                    ? 'Withdraw ₹${controller.availablePayout.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                    : 'Withdraw ₹0';
                
                if (controller.isWithdrawing.value) {
                  return Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF17132F),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF58D6)),
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: isAvailable
                          ? const LinearGradient(
                              colors: [Color(0xFFFF58D6), Color(0xFF8D32F0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isAvailable ? null : const Color(0xFF221F35),
                    ),
                    child: ElevatedButton(
                      onPressed: isAvailable ? controller.withdrawPayout : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          color: isAvailable ? Colors.white : Colors.white24,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              
              // 8. Disclaimer / Commission Info
              const Center(
                child: Text(
                  'Default commission: 20% · Calls commission: 30%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSummaryCard({
    required String label,
    required String value,
    required Color valueColor,
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
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
