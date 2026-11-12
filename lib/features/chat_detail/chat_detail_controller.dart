import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatDetailController extends GetxController {
  final creator = <String, String>{}.obs;
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final messages = <Map<String, dynamic>>[
    {
      'sender': 'creator',
      'text': 'Hey! How are you? 😊',
      'time': '10:00 AM',
    },
    {
      'sender': 'user',
      'text': 'Hi! I\'m good, you?',
      'time': '10:01 AM',
    },
    {
      'sender': 'creator',
      'text': 'Doing great! (chat c1)',
      'time': '10:02 AM',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      creator.addAll(Map<String, String>.from(Get.arguments));
    }
    // Auto scroll to bottom initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();
    
    final timeStr = _formatTime(DateTime.now());
    messages.add({
      'sender': 'user',
      'text': text,
      'time': timeStr,
    });

    _scrollToBottom();

    // Mock response from creator
    Future.delayed(const Duration(milliseconds: 1500), () {
      final responseText = _getMockResponse(text);
      messages.add({
        'sender': 'creator',
        'text': responseText,
        'time': _formatTime(DateTime.now()),
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100, // small buffer
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getMockResponse(String userMsg) {
    final msg = userMsg.toLowerCase();
    if (msg.contains('hello') || msg.contains('hi') || msg.contains('hey')) {
      return 'Hello there! So glad you messaged me! 😊';
    } else if (msg.contains('how are you') || msg.contains('how active')) {
      return 'I\'m doing wonderful, just chatting with some amazing people like you! How is your day going? ✨';
    } else if (msg.contains('price') || msg.contains('coin')) {
      return 'Chatting is only ${creator['chat'] ?? '5 coins/msg'}. Let\'s talk more! 🪙';
    } else {
      return 'That sounds super interesting! Tell me more about it. 💬';
    }
  }
}
