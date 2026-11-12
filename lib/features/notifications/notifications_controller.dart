import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final notificationsList = <Map<String, dynamic>>[
    {
      'title': 'Priya is online!',
      'subtitle': 'Your favourite creator just came online',
      'time': '2m',
    },
    {
      'title': 'Coins added 🎉',
      'subtitle': '1000 coins added to your wallet',
      'time': '1h',
    },
    {
      'title': 'Daily bonus',
      'subtitle': 'Spin the scratch card for ₹200',
      'time': '3h',
    },
    {
      'title': 'New follower',
      'subtitle': 'Ananya started following you',
      'time': '1d',
    },
  ].obs;

  void clearNotification(int index) {
    if (index >= 0 && index < notificationsList.length) {
      notificationsList.removeAt(index);
    }
  }

  void clearAll() {
    notificationsList.clear();
  }
}
