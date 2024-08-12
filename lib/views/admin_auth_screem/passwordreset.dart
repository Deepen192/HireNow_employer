import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/adminAuth_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final AdminAuthController authController = Get.find<AdminAuthController>();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your email here",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _resetPassword(context, authController);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lightGolden,
                elevation: 0, // Set elevation to 0 to remove shadow
              ),
              child: const Text(
                'Reset Password',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context, AdminAuthController authController) async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // Trigger password reset
    var result = await authController.resetPassword(
      email: emailController.text,
      context: context,
    );

    // Close loading indicator
    Get.back();

    if (result) {
      Get.snackbar('Success', 'Password reset email sent', colorText: Colors.black);
      Get.back();
    } else {
      Get.snackbar('Error', 'Email not Found. Please try again.', colorText: Colors.black);
    }
  }
}
