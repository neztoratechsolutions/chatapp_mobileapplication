import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bottom_nav_controller.dart';
import '../home/home_view.dart';
import '../creators/creators_view.dart';
import '../chat/chat_view.dart';
import '../game/game_view.dart';
import '../profile/profile_view.dart';

class BottomNavView extends GetView<BottomNavController> {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.videogame_asset_outlined), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
    ];

    return Scaffold(
      body: Obx(() {
        switch (controller.index.value) {
          case 0:
            return const HomeView();
          case 1:
            return const CreatorsView();
          case 2:
            return const ChatView();
          case 3:
            return const GameView();
          case 4:
            return const ProfileView();
          default:
            return const HomeView();
        }
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            backgroundColor: const Color(0xFF0F0B21),
            currentIndex: controller.index.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFFF58D6),
            unselectedItemColor: Colors.white70,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: items,
          )),
    );
  }
}
