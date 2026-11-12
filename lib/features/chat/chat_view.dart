import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Messages', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('${controller.conversations.length} conversations', style: const TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 22),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.conversations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final convo = controller.conversations[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/chat-detail', arguments: {
                          'name': convo['name'] ?? '',
                          'image': convo['avatar'] ?? '',
                          'chat': '5 coins/min',
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1632),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey.shade800,
                                  backgroundImage: NetworkImage(convo['avatar']),
                                ),
                                if (convo['online'] == true)
                                  Positioned(
                                    right: 0,
                                    bottom: 2,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFF0F0B21), width: 2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(convo['name'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(convo['message'], style: const TextStyle(color: Colors.white70, fontSize: 14), overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(convo['time'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 10),
                                if ((convo['unread'] as int) > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF58D6),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '${convo['unread']}',
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                else
                                  const SizedBox(height: 22),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
