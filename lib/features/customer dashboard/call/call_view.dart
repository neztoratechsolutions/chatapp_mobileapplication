import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'call_controller.dart';

class CallView extends GetView<CallController> {
  const CallView({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFFFF58D6);
    final primaryColor = const Color(0xFF8D32F0);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient with subtle glow
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E103E),
                  Color(0xFF0F0821),
                  Color(0xFF0A0517),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header (Call Type Description)
                Obx(() {
                  final textCallType = controller.callType.value == 'video' ? 'Video call' : 'Voice call';
                  final rateStr = controller.callType.value == 'video' 
                      ? (controller.creator['video'] ?? '30 coins/min')
                      : (controller.creator['voice'] ?? '15 coins/min');
                  return Text(
                    '$textCallType · $rateStr',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  );
                }),
                
                const Spacer(flex: 2),
                
                // Creator Avatar with Glow Ring
                Center(
                  child: Obx(() {
                    final avatarUrl = controller.creator['image'] ?? '';
                    return Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.35),
                            blurRadius: 30,
                            spreadRadius: 6,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: avatarUrl.isNotEmpty
                            ? Image.network(avatarUrl, fit: BoxFit.cover)
                            : Container(
                                color: Colors.grey.shade900,
                                child: const Icon(Icons.person, size: 80, color: Colors.white24),
                              ),
                      ),
                    );
                  }),
                ),
                
                const SizedBox(height: 32),
                
                // Creator Name
                Obx(() => Text(
                  controller.creator['name'] ?? 'Creator',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                
                const SizedBox(height: 10),
                
                // Connection State
                Obx(() {
                  final connected = controller.isConnected.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: connected ? const Color(0xFF00FF7F) : Colors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        connected ? 'Connected' : 'Connecting...',
                        style: TextStyle(
                          color: connected ? const Color(0xFF00FF7F) : Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                }),
                
                const SizedBox(height: 24),
                
                // Dynamic Duration Timer
                Obx(() => Text(
                  controller.formattedDuration,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                )),
                
                const SizedBox(height: 12),
                
                // Coin Balance Counter
                Obx(() => Text(
                  'Balance: ${controller.balance.value} coins',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                )),
                
                const Spacer(flex: 3),
                
                // Custom Navigation/Control Bottom Bar
                Container(
                  margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xE60F0B21),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white10, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTabItem(Icons.home_outlined, 'Home'),
                      Obx(() => _buildCallCircleButton(
                            controller.isMuted.value ? Icons.mic_off : Icons.mic,
                            controller.isMuted.value,
                            controller.toggleMute,
                          )),
                      _buildTabItem(Icons.people_alt_outlined, 'Creators'),
                      _buildGiftCircleButton(),
                      _buildHangUpButton(),
                      _buildTabItem(Icons.chat_bubble_outline, 'Chat'),
                      Obx(() => _buildCallCircleButton(
                            controller.isSpeakerOn.value ? Icons.volume_up : Icons.volume_off,
                            controller.isSpeakerOn.value,
                            controller.toggleSpeaker,
                          )),
                      _buildTabItem(Icons.videogame_asset_outlined, 'Games'),
                      _buildTabItem(Icons.person_outline, 'Profile'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Normal navigation tab item
  Widget _buildTabItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 8),
        ),
      ],
    );
  }

  // Call feature circle buttons (Mute, Speaker)
  Widget _buildCallCircleButton(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? const Color(0xFFFF58D6) : const Color(0xFF221838),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  // Gift button
  Widget _buildGiftCircleButton() {
    return GestureDetector(
      onTap: controller.sendGift,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF221838),
          border: Border.all(color: Colors.white10),
        ),
        child: const Icon(
          Icons.card_giftcard,
          color: Color(0xFFFF58D6),
          size: 18,
        ),
      ),
    );
  }

  // Red Hangup Button
  Widget _buildHangUpButton() {
    return GestureDetector(
      onTap: controller.hangUp,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFF3B30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF3B30).withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            )
          ],
        ),
        child: const Icon(
          Icons.call_end,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
