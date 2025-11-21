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
    // Listen to password changes for real-time validation
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
    nameController.value.clear();
    emailController.value.clear();
    passwordController.value.clear();
    confirmPasswordController.value.clear();
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
    if (!isPasswordValid) {
      return 'Please meet all password requirements';
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

  void triggerShake() {
    shakePasswordRequirements.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      shakePasswordRequirements.value = false;
    });
  }

  // Sign up with email and password
  Future<void> signUpWithEmail() async {
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

      final response = await _supabaseService.signUpWithEmailPassword(
        email: emailController.value.text.trim(),
        password: passwordController.value.text,
        name: nameController.value.text.trim(),
      );

      if (response.user != null) {
        logger.i("Sign up with email successful");
        resetForm();
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
