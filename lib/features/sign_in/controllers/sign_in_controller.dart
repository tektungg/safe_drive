import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';
import 'package:venturo_api_manager/loggers/logger.dart';

class SignInController extends GetxController {
  static SignInController get to => Get.find();

  final SupabaseService _supabaseService = SupabaseService.instance;

  // Form key
  final Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  // Text editing controllers
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> passwordController =
      TextEditingController().obs;

  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  @override
  void onClose() {
    emailController.value.dispose();
    passwordController.value.dispose();
    super.onClose();
  }

  // Validators
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
    return null;
  }

  // Sign in with email and password
  Future<void> signInWithEmail() async {
    if (!formKey.value.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await _supabaseService.signInWithEmailPassword(
        email: emailController.value.text.trim(),
        password: passwordController.value.text,
      );

      if (response.user != null) {
        logger.i("Sign in with email successful");
        Get.snackbar(
          'Success',
          'Successfully signed in!',
          snackPosition: SnackPosition.BOTTOM,
        );

        // TODO: Navigate to home screen
        // Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      logger.e("Error signing in with email: $e");
      Get.snackbar(
        'Error',
        'Failed to sign in: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      isGoogleLoading.value = true;

      final response = await _supabaseService.signInWithGoogle();

      if (response != null && response.user != null) {
        logger.i("Sign in with Google successful");
        Get.snackbar(
          'Success',
          'Successfully signed in with Google!',
          snackPosition: SnackPosition.BOTTOM,
        );

        // TODO: Navigate to home screen
        // Get.offAllNamed(Routes.HOME);
      } else {
        logger.w("Google sign in cancelled");
      }
    } catch (e) {
      logger.e("Error signing in with Google: $e");
      Get.snackbar(
        'Error',
        'Failed to sign in with Google: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }
}
