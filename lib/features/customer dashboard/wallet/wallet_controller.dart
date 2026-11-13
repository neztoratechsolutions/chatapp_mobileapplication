import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final balance = 230.obs;

  final coinPacks = <Map<String, dynamic>>[
    {
      'coins': 100,
      'price': 99,
      'bonus': 0,
      'popular': false,
      'bestValue': false,
    },
    {
      'coins': 500,
      'price': 449,
      'bonus': 50,
      'popular': true,
      'bestValue': false,
    },
    {
      'coins': 1000,
      'price': 849,
      'bonus': 150,
      'popular': false,
      'bestValue': false,
    },
    {
      'coins': 2500,
      'price': 1999,
      'bonus': 500,
      'popular': false,
      'bestValue': false,
    },
    {
      'coins': 5000,
      'price': 3799,
      'bonus': 1200,
      'popular': false,
      'bestValue': true,
    },
  ].obs;

  final selectedPackIndex = 1.obs;
  final selectedPaymentMethod = 'UPI'.obs;
  final paymentMethods = const ['UPI', 'Cards', 'Net Banking', 'Wallets'];

  final transactions = <Map<String, dynamic>>[
    {
      'title': 'Google Play Purchase',
      'subtitle': 'Pack 100 Coins bought',
      'amount': '+100',
      'time': 'Today, 02:30 PM',
      'isCredit': true,
    },
    {
      'title': 'Video Call',
      'subtitle': 'Call with Priya Sharma',
      'amount': '-30',
      'time': 'Yesterday, 10:15 PM',
      'isCredit': false,
    },
    {
      'title': 'Gift Sent',
      'subtitle': 'Heart Gift to Sneha Iyer',
      'amount': '-50',
      'time': '10 Jun 2026, 08:45 PM',
      'isCredit': false,
    },
    {
      'title': 'Check-in Reward',
      'subtitle': 'Daily bonus coins',
      'amount': '+10',
      'time': '09 Jun 2026, 09:00 AM',
      'isCredit': true,
    },
  ].obs;

  void buyPack(Map<String, dynamic> pack) {
    final int coins = pack['coins'] as int;
    final int bonus = pack['bonus'] as int;
    final int price = pack['price'] as int;
    final int totalAdded = coins + bonus;

    balance.value += totalAdded;

    // Add to transaction history
    transactions.insert(0, {
      'title': 'Google Play Purchase',
      'subtitle': 'Pack $coins Coins bought',
      'amount': '+$totalAdded',
      'time': 'Just now',
      'isCredit': true,
    });

    Get.snackbar(
      'Purchase Successful',
      'Added $totalAdded coins (including bonus) to your wallet!',
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

  void paySelectedPack() {
    if (selectedPackIndex.value < 0 || selectedPackIndex.value >= coinPacks.length) return;
    final pack = coinPacks[selectedPackIndex.value];
    buyPack(pack);
    Get.back(); // Navigate back to Wallet page
  }
}
