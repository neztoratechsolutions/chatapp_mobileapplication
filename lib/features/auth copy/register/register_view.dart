import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0x14FFFFFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A0F3A), Color(0xFF0B0718)],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                const Text(
                  'Create your account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'It only takes a minute',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => GestureDetector(
                          onTap: () => controller.toggleAccountType(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: controller.isCustomer.value ? const Color(0xFFFF58D6) : Colors.white12,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: Text(
                                'Customer',
                                style: TextStyle(
                                  color: controller.isCustomer.value ? Colors.white : Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => GestureDetector(
                          onTap: () => controller.toggleAccountType(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: controller.isCustomer.value ? Colors.white12 : const Color(0xFF8D32F0),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: Text(
                                'Creator',
                                style: TextStyle(
                                  color: controller.isCustomer.value ? Colors.white70 : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0x14FFFFFF),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller.fullNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Full name'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller.mobileController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Mobile (+91)'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Email'),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => TextField(
                          controller: controller.passwordController,
                          obscureText: controller.isPasswordHidden.value,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Password').copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: controller.selectedState.value,
                        dropdownColor: const Color(0xFF141229),
                        decoration: _inputDecoration('State'),
                        style: const TextStyle(color: Colors.white),
                        items: const [
                          DropdownMenuItem(value: 'Maharashtra', child: Text('Maharashtra')),
                          DropdownMenuItem(value: 'Karnataka', child: Text('Karnataka')),
                          DropdownMenuItem(value: 'Delhi', child: Text('Delhi')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedState.value = value;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            backgroundColor: const Color(0xFFFF58D6),
                          ),
                          child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: controller.goToLogin,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text('Sign in', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        ),
                      ),
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
}
