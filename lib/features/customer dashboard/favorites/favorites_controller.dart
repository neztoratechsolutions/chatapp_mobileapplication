import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final favorites = <Map<String, dynamic>>[
    {
      'name': 'Priya Sharma',
      'image': 'https://picsum.photos/seed/priya/400/400',
      'rating': 4.7,
      'state': 'Maharashtra',
      'language': 'Hindi',
      'followers': '15,728',
      'bio': "Let's vibe! I love talking about movies, music & late-night thoughts ✨",
      'tag': 'Friendly',
      'price': '5/min',
      'chat': '5 coins/min',
      'voice': '15 coins/min',
      'video': '30 coins/min',
      'online': true,
      'gallery1': 'https://picsum.photos/seed/gallery1/200/200',
      'gallery2': 'https://picsum.photos/seed/gallery2/200/200',
      'gallery3': 'https://picsum.photos/seed/gallery3/200/200',
    },
    {
      'name': 'Ananya Kapoor',
      'image': 'https://picsum.photos/seed/ananya/400/400',
      'rating': 4.7,
      'state': 'Delhi',
      'language': 'English',
      'followers': '12,900',
      'bio': 'Ready for a fun chat? Let’s discover your vibe together.',
      'tag': 'Friendly',
      'price': '7/min',
      'chat': '7 coins/min',
      'voice': '17 coins/min',
      'video': '32 coins/min',
      'online': false,
      'gallery1': 'https://picsum.photos/seed/gallery4/200/200',
      'gallery2': 'https://picsum.photos/seed/gallery5/200/200',
      'gallery3': 'https://picsum.photos/seed/gallery6/200/200',
    },
    {
      'name': 'Riya Verma',
      'image': 'https://picsum.photos/seed/riya/400/400',
      'rating': 4.4,
      'state': 'Karnataka',
      'language': 'Hindi',
      'followers': '10,540',
      'bio': 'Let’s talk about your favorite songs, travel plans, and late-night dreams.',
      'tag': 'Chill',
      'price': '9/min',
      'chat': '9 coins/min',
      'voice': '18 coins/min',
      'video': '35 coins/min',
      'online': false,
      'gallery1': 'https://picsum.photos/seed/gallery7/200/200',
      'gallery2': 'https://picsum.photos/seed/gallery8/200/200',
      'gallery3': 'https://picsum.photos/seed/gallery9/200/200',
    },
    {
      'name': 'Sneha Iyer',
      'image': 'https://picsum.photos/seed/sneha/400/400',
      'rating': 4.9,
      'state': 'Tamil Nadu',
      'language': 'English',
      'followers': '18,900',
      'bio': 'A cozy conversation about pop culture, memories, and late-night stories.',
      'tag': 'Friendly',
      'price': '11/min',
      'chat': '11 coins/min',
      'voice': '20 coins/min',
      'video': '40 coins/min',
      'online': true,
      'gallery1': 'https://picsum.photos/seed/gallery10/200/200',
      'gallery2': 'https://picsum.photos/seed/gallery11/200/200',
      'gallery3': 'https://picsum.photos/seed/gallery12/200/200',
    },
    {
      'name': 'Kavya Reddy',
      'image': 'https://picsum.photos/seed/kavya/400/400',
      'rating': 4.8,
      'state': 'Gujarat',
      'language': 'Hindi',
      'followers': '14,200',
      'bio': "Hello! Let's build a nice bond and share deep conversations together.",
      'tag': 'Chill',
      'price': '13/min',
      'chat': '13 coins/min',
      'voice': '22 coins/min',
      'video': '45 coins/min',
      'online': true,
      'gallery1': 'https://picsum.photos/seed/gallery13/200/200',
      'gallery2': 'https://picsum.photos/seed/gallery14/200/200',
      'gallery3': 'https://picsum.photos/seed/gallery15/200/200',
    },
    {
      'name': 'Aisha Khan',
      'image': 'https://picsum.photos/seed/aisha/400/400',
      'rating': 4.7,
      'state': 'Rajasthan',
      'language': 'Hindi',
      'followers': '9,800',
      'bio': 'I am friendly, outgoing, and ready to talk about anything! Hit me up.',
      'tag': 'Friendly',
      'price': '5/min',
      'chat': '5 coins/min',
      'voice': '15 coins/min',
      'video': '30 coins/min',
      'online': false,
      'gallery1': 'https://picsum.photos/seed/gallery16/200/200',
      'gallery2': 'https://picsum.photos/seed/gallery17/200/200',
      'gallery3': 'https://picsum.photos/seed/gallery18/200/200',
    },
  ].obs;

  void removeFavorite(int index) {
    if (index >= 0 && index < favorites.length) {
      favorites.removeAt(index);
    }
  }

  void toggleFavorite(Map<String, dynamic> creator) {
    final name = creator['name'];
    final idx = favorites.indexWhere((c) => c['name'] == name);
    if (idx != -1) {
      favorites.removeAt(idx);
    } else {
      favorites.add(creator);
    }
  }

  bool isFavorite(String creatorName) {
    return favorites.any((c) => c['name'] == creatorName);
  }
}
