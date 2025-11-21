import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';
import 'package:venturo_api_manager/loggers/logger.dart';

class SignUpController extends GetxController {
  static SignUpController get to => Get.find();

  final SupabaseService _supabaseService = SupabaseService.instance;

  // Form key
  final Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  // Text editing controllers
  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> passwordController =
      TextEditingController().obs;
  final Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    nameController.value.dispose();
    emailController.value.dispose();
    passwordController.value.dispose();
    confirmPasswordController.value.dispose();
    super.onClose();
  }

  // Validators
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.value.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Sign up with email and password
  Future<void> signUpWithEmail() async {
    if (!formKey.value.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await _supabaseService.signUpWithEmailPassword(
        email: emailController.value.text.trim(),
        password: passwordController.value.text,
        name: nameController.value.text.trim(),
      );

      if (response.user != null) {
        logger.i("Sign up with email successful");
        Get.snackbar(
          'Success',
          'Account created successfully! Please check your email to verify your account.',
          snackPosition: SnackPosition.BOTTOM,
        );

        // TODO: Navigate to sign in or home screen
        // Get.offAllNamed(Routes.SIGN_IN);
      }
    } catch (e) {
      logger.e("Error signing up with email: $e");
      Get.snackbar(
        'Error',
        'Failed to create account: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
