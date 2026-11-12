import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'creators_controller.dart';
import 'creator_details_view.dart';

class CreatorsView extends GetView<CreatorsController> {
  const CreatorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Creators', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('20 creators available', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, color: Colors.white70),
                    label: const Text('Filters', style: TextStyle(color: Colors.white70)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.filters.map((f) {
                        final selected = controller.selectedFilter.value == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () => controller.selectFilter(f),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? const Color(0xFFFF58D6) : Colors.white12,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  if (f == 'Online only')
                                    Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                                  if (f == 'Online only') const SizedBox(width: 8),
                                  Text(f, style: TextStyle(color: selected ? Colors.white : Colors.white70)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  final list = controller.displayed;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final c = list[index];
                      final creatorMap = c.map((key, val) => MapEntry(key, val.toString()));
                      return GestureDetector(
                        onTap: () => Get.to(() => CreatorDetailsView(creator: creatorMap)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  c['image'],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(color: Colors.black26);
                                  },
                                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade900),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(color: c['online'] ? Colors.green : Colors.transparent, shape: BoxShape.circle, border: Border.all(color: Colors.white70)),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 96,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.2)]),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.star, color: Colors.yellow, size: 14),
                                                const SizedBox(width: 6),
                                                Text('${c['rating']}', style: const TextStyle(color: Colors.white70)),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Text('· ${c['state']}', style: const TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(c['price'], style: const TextStyle(color: Color(0xFFFF58D6), fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
