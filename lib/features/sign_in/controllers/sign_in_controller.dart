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

  // Password validation states
  final RxBool hasMinLength = false.obs;
  final RxBool hasLowercase = false.obs;
  final RxBool hasUppercase = false.obs;
  final RxBool hasNumber = false.obs;
  final RxBool hasSymbol = false.obs;

  // Password focus state
  final RxBool isPasswordFocused = false.obs;

  // Shake animation trigger
  final RxBool shakePasswordRequirements = false.obs;

  @override
  void onInit() {
    super.onInit();
    passwordController.value.addListener(_validatePasswordRealtime);
  }

  void _validatePasswordRealtime() {
    final password = passwordController.value.text;
    hasMinLength.value = password.length >= 6;
    hasLowercase.value = password.contains(RegExp(r'[a-z]'));
    hasUppercase.value = password.contains(RegExp(r'[A-Z]'));
    hasNumber.value = password.contains(RegExp(r'[0-9]'));
    hasSymbol.value = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  bool get isPasswordValid =>
      hasMinLength.value &&
      hasLowercase.value &&
      hasUppercase.value &&
      hasNumber.value &&
      hasSymbol.value;

  void resetForm() {
    formKey.value.currentState?.reset();
    emailController.value.clear();
    passwordController.value.clear();
    hasMinLength.value = false;
    hasLowercase.value = false;
    hasUppercase.value = false;
    hasNumber.value = false;
    hasSymbol.value = false;
    isPasswordFocused.value = false;
  }

  @override
  void onClose() {
    passwordController.value.removeListener(_validatePasswordRealtime);
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

  void triggerShake() {
    shakePasswordRequirements.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      shakePasswordRequirements.value = false;
    });
  }

  // Sign in with email and password
  Future<void> signInWithEmail() async {
    // Check password requirements first
    if (!isPasswordValid && passwordController.value.text.isNotEmpty) {
      isPasswordFocused.value = true;
      triggerShake();
      return;
    }

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
        resetForm();
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
        resetForm();
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
