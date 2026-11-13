import 'package:get/get.dart';

class ChatController extends GetxController {
  final conversations = <Map<String, dynamic>>[
    {
      'name': 'Priya Sharma',
      'avatar': 'https://picsum.photos/seed/priya-chat/200/200',
      'message': 'Hey! 👋',
      'time': 'now',
      'unread': 1,
      'online': true,
    },
    {
      'name': 'Ananya Kapoor',
      'avatar': 'https://picsum.photos/seed/ananya-chat/200/200',
      'message': 'Call me na',
      'time': '2m',
      'unread': 2,
      'online': true,
    },
    {
      'name': 'Riya Verma',
      'avatar': 'https://picsum.photos/seed/riya-chat/200/200',
      'message': 'haha 😂',
      'time': '10m',
      'unread': 0,
      'online': true,
    },
    {
      'name': 'Sneha Iyer',
      'avatar': 'https://picsum.photos/seed/sneha-chat/200/200',
      'message': 'Tomorrow?',
      'time': '1h',
      'unread': 0,
      'online': false,
    },
    {
      'name': 'Kavya Reddy',
      'avatar': 'https://picsum.photos/seed/kavya-chat/200/200',
      'message': 'Online?',
      'time': 'yesterday',
      'unread': 0,
      'online': false,
    },
    {
      'name': 'Aisha Khan',
      'avatar': 'https://picsum.photos/seed/aisha-chat/200/200',
      'message': 'Hey! 👋',
      'time': 'now',
      'unread': 0,
      'online': true,
    },
  ].obs;
}

