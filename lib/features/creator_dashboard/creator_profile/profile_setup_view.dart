import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_setup_controller.dart';

class ProfileSetupView extends GetView<ProfileSetupController> {
  const ProfileSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0B21),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        ),
        title: const Text(
          'Profile Setup',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFFFF58D6)),
            onPressed: controller.fetchUserProfile,
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF58D6),
                strokeWidth: 3,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profile Photo with Edit Button
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF58D6), Color(0xFF8D32F0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF58D6).withOpacity(0.35),
                                blurRadius: 16,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: _buildAvatarWidget(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF58D6),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF0F0B21), width: 2.5),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 2. Personal Information Section
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),

                // Display Name (Editable)
                _buildEditableField(
                  label: 'Display Name',
                  controller: controller.displayNameController,
                  icon: Icons.person_outline_rounded,
                  hint: 'Enter your display name',
                  onChanged: (val) => controller.displayName.value = val,
                ),
                const SizedBox(height: 14),

                // Email Address
                _buildReadOnlyCard(
                  label: 'Email Address',
                  value: controller.email.value.isNotEmpty ? controller.email.value : '—',
                  icon: Icons.email_outlined,
                  iconColor: const Color(0xFFFF58D6),
                ),
                const SizedBox(height: 14),

                // Phone Number
                _buildReadOnlyCard(
                  label: 'Phone Number',
                  value: controller.phone.value.isNotEmpty ? controller.phone.value : '—',
                  icon: Icons.phone_outlined,
                  iconColor: const Color(0xFF00C853),
                ),
                const SizedBox(height: 14),

                // Gender & State Row
                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyCard(
                        label: 'Gender',
                        value: controller.gender.value.isNotEmpty ? controller.gender.value : '—',
                        icon: Icons.transgender_rounded,
                        iconColor: const Color(0xFF8D32F0),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showStatePicker(context),
                        child: _buildReadOnlyCard(
                          label: 'State',
                          value: controller.stateName.value.isNotEmpty ? controller.stateName.value : 'Select State',
                          icon: Icons.location_on_outlined,
                          iconColor: const Color(0xFFFFB300),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // 3. Bio & Description Section
                const Text(
                  'Bio & Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),

                // Bio (Editable)
                _buildEditableField(
                  label: 'Bio',
                  controller: controller.bioController,
                  icon: Icons.edit_note_rounded,
                  hint: 'Short bio about yourself',
                  maxLines: 2,
                  onChanged: (val) => controller.bio.value = val,
                ),
                const SizedBox(height: 14),

                // Description (Editable)
                _buildEditableField(
                  label: 'Description',
                  controller: controller.descriptionController,
                  icon: Icons.notes_rounded,
                  hint: 'Detailed description about your content',
                  maxLines: 3,
                  onChanged: (val) => controller.description.value = val,
                ),
                const SizedBox(height: 36),

                // 4. Save Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: controller.isSaving.value ? null : controller.saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF58D6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isSaving.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text(
                            'Save Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAvatarWidget() {
    return Obx(() {
      // 1. Newly picked local file
      final localPath = controller.selectedImagePath.value;
      if (localPath.isNotEmpty) {
        final localFile = File(localPath);
        if (localFile.existsSync()) {
          return Image.file(
            localFile,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildAvatarInitial(),
          );
        }
      }

      // 2. Profile photo from API URL
      final url = controller.fullPhotoUrl;
      if (url.isNotEmpty) {
        return Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF58D6)),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('[IMAGE_LOAD_ERROR] Failed loading image from: $url ($error)');
            return _buildAvatarInitial();
          },
        );
      }

      return _buildAvatarInitial();
    });
  }

  Widget _buildAvatarInitial() {
    final char = controller.displayName.value.isNotEmpty
        ? controller.displayName.value[0].toUpperCase()
        : 'U';
    return Center(
      child: Text(
        char,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReadOnlyCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF17132F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    int maxLines = 1,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF17132F),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
            prefixIcon: maxLines == 1
                ? Icon(icon, color: const Color(0xFFFF58D6), size: 20)
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFFF58D6), width: 1.5),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _showStatePicker(BuildContext context) {
    if (controller.statesList.isEmpty) return;

    Get.bottomSheet(
      Container(
        height: 350,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF17132F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select State',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.statesList.length,
                  itemBuilder: (context, index) {
                    final state = controller.statesList[index];
                    return ListTile(
                      title: Text(state.name, style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        controller.selectState(state);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
