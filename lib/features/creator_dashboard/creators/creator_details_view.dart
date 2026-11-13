import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../customer dashboard/favorites/favorites_controller.dart';

class CreatorDetailsView extends StatelessWidget {
  final Map<String, String> creator;

  const CreatorDetailsView({super.key, required this.creator});

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFFFF58D6);
    final favoritesController = Get.isRegistered<FavoritesController>() ? Get.find<FavoritesController>() : null;
    return Scaffold(
      backgroundColor: const Color(0xFF120B28),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Spacer(),
                  if (favoritesController != null)
                    Obx(() {
                      final isFav = favoritesController.isFavorite(creator['name'] ?? '');
                      return IconButton(
                        onPressed: () => favoritesController.toggleFavorite(creator),
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? accent : Colors.white70,
                        ),
                      );
                    })
                  else
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border, color: Colors.white70),
                    ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.card_giftcard, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: const LinearGradient(colors: [Color(0xFF8D32F0), Color(0xFFFF58D6)]),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            creator['image'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade900),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  creator['name'] ?? 'Creator',
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  '${creator['state'] ?? ''} · ${creator['language'] ?? ''}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.yellow, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    creator['rating'] ?? '4.7',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${creator['followers'] ?? '0'} followers',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1834),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  creator['bio'] ?? '',
                  style: const TextStyle(color: Colors.white70, height: 1.6),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    creator['tag'] ?? 'Friendly',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Follow'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (favoritesController != null)
                    Obx(() {
                      final isFav = favoritesController.isFavorite(creator['name'] ?? '');
                      return GestureDetector(
                        onTap: () => favoritesController.toggleFavorite(creator),
                        child: _buildCircleAction(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? accent : Colors.white70,
                        ),
                      );
                    })
                  else
                    _buildCircleAction(Icons.favorite_border),
                  const SizedBox(width: 12),
                  _buildCircleAction(Icons.card_giftcard),
                ],
              ),
              const SizedBox(height: 28),
              const Text('Services', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildServiceCard(
                    Icons.chat_bubble_outline,
                    'Chat',
                    creator['chat'] ?? '5 coins/min',
                    onTap: () => Get.toNamed('/chat-detail', arguments: creator),
                  ),
                  const SizedBox(width: 10),
                  _buildServiceCard(
                    Icons.call,
                    'Voice',
                    creator['voice'] ?? '15 coins/min',
                    onTap: () => Get.toNamed('/call', arguments: {'creator': creator, 'callType': 'voice'}),
                  ),
                  const SizedBox(width: 10),
                  _buildServiceCard(
                    Icons.videocam,
                    'Video',
                    creator['video'] ?? '30 coins/min',
                    onTap: () => Get.toNamed('/call', arguments: {'creator': creator, 'callType': 'video'}),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Gallery', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildGalleryImage(creator['gallery1'] ?? creator['image'] ?? ''),
                  const SizedBox(width: 10),
                  _buildGalleryImage(creator['gallery2'] ?? creator['image'] ?? ''),
                  const SizedBox(width: 10),
                  _buildGalleryImage(creator['gallery3'] ?? creator['image'] ?? ''),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, {Color color = Colors.white70}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF221838),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget _buildServiceCard(IconData icon, String title, String label, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1834),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryImage(String imageUrl) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade900),
          ),
        ),
      ),
    );
  }
}
