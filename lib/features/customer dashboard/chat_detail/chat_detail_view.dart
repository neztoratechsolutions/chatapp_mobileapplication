import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_detail_controller.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFFFF58D6);
    final primaryColor = const Color(0xFF8D32F0);
    final textPrice = (controller.creator['chat'] ?? '5 coins/min').replaceAll('min', 'msg');

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      body: SafeArea(
        child: Column(
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
                  Obx(() {
                    final avatarUrl = controller.creator['image'] ?? '';
                    return CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade900,
                      backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                      child: avatarUrl.isEmpty
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    );
                  }),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              controller.creator['name'] ?? 'Creator',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Online',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.card_giftcard, color: accentColor, size: 24),
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed('/call', arguments: {
                      'creator': Map<String, String>.from(controller.creator),
                      'callType': 'voice',
                    }),
                    icon: const Icon(Icons.phone_outlined, color: Colors.white70, size: 24),
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed('/call', arguments: {
                      'creator': Map<String, String>.from(controller.creator),
                      'callType': 'video',
                    }),
                    icon: const Icon(Icons.videocam_outlined, color: Colors.white70, size: 24),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10, height: 1),

            // Message List Area
            Expanded(
              child: Obx(() => ListView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final msg = controller.messages[index];
                      final isUser = msg['sender'] == 'user';

                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            gradient: isUser
                                ? LinearGradient(
                                    colors: [primaryColor, accentColor],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color: isUser ? null : const Color(0xFF1B1632),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            border: isUser ? null : Border.all(color: Colors.white12),
                          ),
                          child: Text(
                            msg['text'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      );
                    },
                  )),
            ),

            // Bottom Input Panel
            Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0, bottom: 8.0),
              decoration: const BoxDecoration(
                color: Color(0xFF0F0B21),
                border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.white70, size: 28),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white70, size: 28),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1632),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: TextField(
                            controller: controller.messageController,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: 'Message · $textPrice',
                              hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            onSubmitted: (_) => controller.sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: controller.sendMessage,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [primaryColor, accentColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.toll_outlined, color: Colors.white38, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '$textPrice · 10 coins/image',
                        style: const TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
