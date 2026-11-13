import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final name = 'Aarav User'.obs;
  final email = 'd@gmail.com'.obs;
  final phone = '+91 98765 43210'.obs;
  final location = 'Maharashtra'.obs;

  final profileMenu = <Map<String, dynamic>>[
    {'title': 'Edit Profile', 'icon': Icons.edit},
    {'title': 'Wallet', 'icon': Icons.account_balance_wallet_outlined},
    {'title': 'My Gifts Sent', 'icon': Icons.card_giftcard_outlined},
    {'title': 'Favorite Creators', 'icon': Icons.favorite_border},
    {'title': 'Rewards & Check-in', 'icon': Icons.emoji_events_outlined},
    {'title': 'Notifications', 'icon': Icons.notifications_none},
    {'title': 'Games', 'icon': Icons.videogame_asset_outlined},
    {'title': 'Settings', 'icon': Icons.settings_outlined},
  ].obs;
}

