import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../creator_dashboard/creators/creator_details_view.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFFFF58D6);
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Color(0xFF8D32F0), Color(0xFFFF58D6)]),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Velora', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(width: 4),
                    Text('Live', style: TextStyle(color: Color(0xFFFF58D6), fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Get.toNamed('/search'),
                icon: const Icon(Icons.search, color: Colors.white70),
              ),
              IconButton(onPressed: () => Get.toNamed('/rewards'), icon: const Icon(Icons.card_giftcard, color: Colors.white70)),
              IconButton(onPressed: () => Get.toNamed('/notifications'), icon: const Icon(Icons.notifications_none, color: Colors.white70)),
              GestureDetector(
                onTap: () => Get.toNamed('/wallet'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFFFDCA8), borderRadius: BorderRadius.circular(20)),
                  child: Row(children: const [Icon(Icons.monetization_on, size: 16), SizedBox(width: 6), Text('500', style: TextStyle(fontWeight: FontWeight.bold))]),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [Color(0xFF2A1740), Color(0xFF0F0816)]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Today's pick", style: TextStyle(color: Colors.pinkAccent)),
                const SizedBox(height: 8),
                const Text('Connect with creators', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const Text('live now', style: TextStyle(color: Color(0xFFFF58D6), fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('312 creators online. Find your vibe instantly.', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)), padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12)),
                  child: const Text('Browse all', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: const [Icon(Icons.local_fire_department, color: Colors.orange), SizedBox(width: 8), Text('Online now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))]),
              TextButton(onPressed: () {}, child: const Text('See all', style: TextStyle(color: Color(0xFFFF58D6))))
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: Obx(() => ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, i) {
                final user = controller.online[i];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFFEA4DFF), Color(0xFFFF58D6)])),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white10,
                        backgroundImage: NetworkImage(user['image']!),
                        onBackgroundImageError: (_, __) {},
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(width: 70, child: Text(user['name']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)))
                  ],
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: controller.online.length,
            )),
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Trending creators', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), TextButton(onPressed: () {}, child: const Text('See all', style: TextStyle(color: Color(0xFFFF58D6))))]),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: Obx(() => ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                final t = controller.trending[i];
                return InkWell(
                  onTap: () => Get.to(() => CreatorDetailsView(creator: t)),
                  borderRadius: BorderRadius.circular(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            t['image']!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(color: Colors.black12);
                            },
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade900),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          bottom: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t['name'] ?? t['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('${t['state'] ?? ''} · ${t['language'] ?? ''}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.local_fire_department, color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: controller.trending.length,
            )),
          ),
          const SizedBox(height: 80),
        ],
      ),
      )
    );

  }
}
