import 'package:get/get.dart';

class CreatorsController extends GetxController {
  final filters = ['Online only', 'All', 'Maharashtra', 'Delhi', 'Karnataka'].obs;
  final selectedFilter = 'All'.obs;

  final creators = <Map<String, dynamic>>[
    {
      'name': 'Priya Sharma',
      'image': 'https://picsum.photos/seed/priya/400/400',
      'rating': 4.1,
      'state': 'Maharashtra',
      'price': '5 coins/min',
      'online': true,
    },
    {
      'name': 'Ananya Kapoor',
      'image': 'https://picsum.photos/seed/ananya/400/400',
      'rating': 4.4,
      'state': 'Delhi',
      'price': '7 coins/min',
      'online': true,
    },
    {
      'name': 'Riya Verma',
      'image': 'https://picsum.photos/seed/riya/400/400',
      'rating': 4.0,
      'state': 'Karnataka',
      'price': '9 coins/min',
      'online': false,
    },
    {
      'name': 'Sneha Iyer',
      'image': 'https://picsum.photos/seed/sneha/400/400',
      'rating': 4.5,
      'state': 'Tamil Nadu',
      'price': '8 coins/min',
      'online': true,
    },
    {
      'name': 'Kavya Singh',
      'image': 'https://picsum.photos/seed/kavya/400/400',
      'rating': 4.2,
      'state': 'Maharashtra',
      'price': '6 coins/min',
      'online': false,
    },
  ].obs;

  List<Map<String, dynamic>> get displayed {
    if (selectedFilter.value == 'All') return creators;
    if (selectedFilter.value == 'Online only') {
      return creators.where((c) => c['online'] == true).toList();
    }
    return creators.where((c) => c['state'] == selectedFilter.value).toList();
  }

  void selectFilter(String f) => selectedFilter.value = f;
}

