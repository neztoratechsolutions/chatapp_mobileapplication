import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'creator_gallery_controller.dart';

class CreatorGalleryView extends GetView<CreatorGalleryController> {
  const CreatorGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Back Button
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => Text(
                'Upload up to 8 photos (${controller.images.length}/8 uploaded)',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                ),
              )),
              const SizedBox(height: 24),

              // 5. Gallery Photo Grid
              Obx(() {
                final int totalItems = controller.images.length + (controller.images.length < 8 ? 1 : 0);
                
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: totalItems,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    if (index == controller.images.length) {
                      // Render "+" / Upload Button
                      return _buildAddButtonCard(context);
                    }
                    
                    final item = controller.images[index];
                    return _buildImageCard(context, item);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildImageCard(BuildContext context, GalleryItem item) {
    return GestureDetector(
      onTap: () => _showImageOptions(context, item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: item.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: item.colors.first.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButtonCard(BuildContext context) {
    return Obx(() {
      if (controller.isUploading.value) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF17132F),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF58D6)),
              ),
            ),
          ),
        );
      }

      return GestureDetector(
        onTap: controller.uploadImage,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF17132F),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10, width: 1.5),
          ),
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              color: Colors.white60,
              size: 32,
            ),
          ),
        ),
      );
    });
  }

  void _showImageOptions(BuildContext context, GalleryItem item) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF17132F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: item.colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gallery Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Would you like to remove this photo from your creator gallery?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.deleteImage(item.id);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
