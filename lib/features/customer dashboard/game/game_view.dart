import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'game_controller.dart';

class GameView extends GetView<GameController> {
  const GameView({super.key});

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Games Zone', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text('Play & win real rewards', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_events, size: 18),
                    label: const Text('Leaderboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B1632),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Obx(
                  () => ListView.separated(
                    itemCount: controller.games.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final game = controller.games[index];
                      return Container(
                        height: 190,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: List<Color>.from(game['colors']),
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 8)),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 18,
                              top: 18,
                              child: game['topRightType'] == 'dots'
                                  ? Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: List.generate(
                                        9,
                                        (dotIndex) => Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.75),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(game['icon'], color: Colors.white, size: 24),
                                    ),
                            ),
                            Positioned(
                              left: 18,
                              right: 18,
                              top: 28,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(game['title'], style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text(game['subtitle'], style: const TextStyle(color: Colors.white70, fontSize: 16)),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 18,
                              right: 18,
                              bottom: 18,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Entry: ${game['entry']}', style: const TextStyle(color: Colors.white70, fontSize: 15)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0E6238),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Text(game['reward'], style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
