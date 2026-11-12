import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  final games = <Map<String, dynamic>>[
    {
      'title': 'Color Connect',
      'subtitle': 'Match colors & win ₹200',
      'entry': '₹100',
      'reward': 'Win up to ₹200',
      'colors': [Color(0xFFEF6CC7), Color(0xFF7C5BFF)],
      'icon': Icons.circle,
      'topRightType': 'dots',
    },
    {
      'title': 'Scratch & Win',
      'subtitle': 'Reveal your daily prize',
      'entry': '₹100',
      'reward': 'Win up to ₹200',
      'colors': [Color(0xFFFFA600), Color(0xFFFF7A00)],
      'icon': Icons.auto_awesome,
      'topRightType': 'icon',
    },
  ].obs;
}
