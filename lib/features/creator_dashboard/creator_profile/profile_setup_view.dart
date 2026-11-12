import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_setup_controller.dart';

class ProfileSetupView extends GetView<ProfileSetupController> {
  const ProfileSetupView({super.key});

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
                    'Profile Setup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Profile Setup Content directly
              _buildProfileSetupContent(),
            ],
          ),
        ),
      ),
    );
  }



  // Profile Setup Tab Content
  Widget _buildProfileSetupContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Setup',
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Set up your creator profile',
          style: TextStyle(color: Colors.white60, fontSize: 15),
        ),
        const SizedBox(height: 32),

        // Profile Photo Section
        Center(
          child: Column(
            children: [
              Obx(
                () => GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF58D6), Color(0xFF8D32F0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: controller.selectedImagePath.value.isNotEmpty && controller.selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              controller.selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Text(
                              controller.displayName.value.isNotEmpty
                                  ? controller.displayName.value[0].toUpperCase()
                                  : 'R',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFF58D6), width: 1.5),
                  ),
                  child: const Text(
                    'Change photo',
                    style: TextStyle(
                      color: Color(0xFFFF58D6),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Display Name Field
        const Text(
          'Display name',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.displayNameController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF17132F),
            hintText: 'Enter your display name',
            hintStyle: const TextStyle(color: Colors.white38),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
          onChanged: controller.onDisplayNameChanged,
        ),
        const SizedBox(height: 24),

        // Bio Field
        const Text(
          'Bio',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.bioController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          maxLines: 4,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF17132F),
            hintText: 'Write something about yourself',
            hintStyle: const TextStyle(color: Colors.white38),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
          onChanged: controller.onBioChanged,
        ),
        const SizedBox(height: 32),

        // Save Button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: controller.saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF58D6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
