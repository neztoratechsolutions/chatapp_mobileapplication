import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'search_controller.dart';
import '../../creator_dashboard/creators/creator_details_view.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFFFF58D6);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Color(0xFF8D32F0), Color(0xFFFF58D6)]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Velora',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    'Live',
                    style: TextStyle(
                      color: Color(0xFFFF58D6),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.card_giftcard, color: Colors.white70, size: 22),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none, color: Colors.white70, size: 22),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDCA8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.monetization_on, size: 14, color: Color(0xFFD48F00)),
                        SizedBox(width: 4),
                        Text(
                          '300',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),

            // Search input capsule
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0B21),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: accentColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white54, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: (val) => controller.searchQuery.value = val,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'Search creators...',
                          hintStyle: TextStyle(color: Colors.white38, fontSize: 15),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Suggested Label
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Suggested',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Creators List
            Expanded(
              child: Obx(() {
                final list = controller.filteredCreators;
                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      'No creators found',
                      style: TextStyle(color: Colors.white38, fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final isOnline = item['online'] == true;

                    return GestureDetector(
                      onTap: () {
                        // Convert dynamic values to string for CreatorDetailsView
                        final creatorMap = item.map((key, val) => MapEntry(key, val.toString()));
                        Get.to(() => CreatorDetailsView(creator: creatorMap));
                      },
                      child: Container(
                        height: 84,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1632),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.grey.shade900,
                                  backgroundImage: NetworkImage(item['image']),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: isOnline ? Colors.green : const Color(0xFF424242),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFF1B1632), width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.yellow, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${item['rating']}',
                                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                                      ),
                                      const Text(' • ', style: TextStyle(color: Colors.white30)),
                                      Text(
                                        item['state'],
                                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              item['price'],
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
