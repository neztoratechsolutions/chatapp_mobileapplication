import 'dart:async';
import 'package:get/get.dart';
import"package:flutter/material.dart";


class CallController extends GetxController {
  final creator = <String, String>{}.obs;
  final callType = 'voice'.obs;
  
  final isConnected = false.obs;
  final duration = 0.obs;
  final isMuted = false.obs;
  final isSpeakerOn = false.obs;
  final balance = 500.obs;

  Timer? _callTimer;
  Timer? _connectTimer;

  String get formattedDuration {
    final minutes = (duration.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  int get ratePerMin {
    final rateStr = callType.value == 'video' 
        ? (creator['video'] ?? '30') 
        : (creator['voice'] ?? '15');
    // Extract numbers from strings like "15 coins/min"
    final cleanStr = rateStr.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanStr) ?? (callType.value == 'video' ? 30 : 15);
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['creator'] != null) {
        creator.addAll(Map<String, String>.from(args['creator']));
      }
      if (args['callType'] != null) {
        callType.value = args['callType'].toString();
      }
    }
    _startConnecting();
  }

  @override
  void onClose() {
    _connectTimer?.cancel();
    _callTimer?.cancel();
    super.onClose();
  }

  void _startConnecting() {
    _connectTimer = Timer(const Duration(milliseconds: 1200), () {
      isConnected.value = true;
      _startCallTimer();
    });
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration.value++;
      
      // Deduct coins every 60 seconds (1 minute)
      if (duration.value > 0 && duration.value % 60 == 0) {
        final currentRate = ratePerMin;
        if (balance.value >= currentRate) {
          balance.value -= currentRate;
        } else {
          // Out of balance, auto hang up
          hangUp();
          Get.snackbar(
            'Call Ended',
            'Insufficient coin balance to continue the call.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFFF58D6).withOpacity(0.9),
            colorText: const Color(0xFFFFFFFF),
          );
        }
      }
    });
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
  }

  void toggleSpeaker() {
    isSpeakerOn.value = !isSpeakerOn.value;
  }

  void hangUp() {
    _connectTimer?.cancel();
    _callTimer?.cancel();
    Get.back();
  }

  void sendGift() {
    if (balance.value >= 50) {
      balance.value -= 50;
      Get.snackbar(
        'Gift Sent 🎁',
        'You sent a sweet gift to ${creator['name'] ?? 'Creator'} (50 coins)',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF8D32F0).withOpacity(0.9),
        colorText: const Color(0xFFFFFFFF),
      );
    } else {
      Get.snackbar(
        'Insufficient Coins',
        'You need at least 50 coins to send a gift.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFF58D6).withOpacity(0.9),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }
}
