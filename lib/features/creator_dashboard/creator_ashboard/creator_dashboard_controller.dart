import 'package:get/get.dart';

class CreatorDashboardController extends GetxController {
  // Selected tab: 'Inbox', 'Reviews', 'Settings'
  final selectedTab = 'Reviews'.obs;
  
  // Status: Online / Offline
  final isOnline = true.obs;

  // Mock creator details
  final creatorName = 'Riya'.obs;
  
  // Statistics data
  final todayEarnings = '₹1,840'.obs;
  final followersCount = '2,341'.obs;
  final callsCount = '23'.obs;
  final ratingValue = '4.8'.obs;
  final weeklyEarnings = '₹12,450'.obs;

  // Mock reviews list matching the screenshot
  final reviews = <Map<String, dynamic>>[
    {
      'name': 'Aarav',
      'time': '2d',
      'rating': 5,
      'comment': 'Such a fun chat! 💯',
    },
    {
      'name': 'Rohan',
      'time': '5d',
      'rating': 4,
      'comment': 'Loved the energy, will call again.',
    },
    {
      'name': 'Karan',
      'time': '1w',
      'rating': 5,
      'comment': 'Amazing host, very kind.',
    },
  ].obs;

  // Mock conversations list for Inbox tab
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

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
  }

  void changeTab(String tabName) {
    selectedTab.value = tabName;
  }

  void navigateToTool(String routeName) {
    Get.toNamed(routeName);
  }

  void logout() {
    Get.offAllNamed('/login');
  }
}
