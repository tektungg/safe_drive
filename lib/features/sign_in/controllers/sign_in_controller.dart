import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/shared/widgets/custom_loading_overlay_widget.dart';
import 'package:safe_drive/shared/widgets/custom_toast_widget.dart';
import 'package:safe_drive/utils/helpers/supabase_error_handler.dart';
import 'package:safe_drive/utils/services/connectivity_service.dart';
import 'package:safe_drive/utils/services/hive_service.dart';
import 'package:safe_drive/utils/services/logger_service.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';

class SignInController extends GetxController {
  static SignInController get to => Get.find();

  final SupabaseService _supabaseService = SupabaseService.instance;
  final HiveService _hiveService = Get.find<HiveService>();

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

  // Remember me state (Auto-login feature)
  final RxBool rememberMe = false.obs;

  // Rate limiting states
  final RxInt failedAttempts = 0.obs;
  final Rx<DateTime?> lockoutUntil = Rx<DateTime?>(null);

  // Hive keys
  static const String _rememberMeKey = 'remember_me_enabled';
  static const String _lastLoginKey = 'last_login_timestamp';
  static const String _failedAttemptsKey = 'failed_attempts';
  static const String _lockoutUntilKey = 'lockout_until';

  @override
  void onInit() {
    super.onInit();
    passwordController.value.addListener(_validatePasswordRealtime);
    _loadRateLimitData();
  }

  /// Load rate limit data from Hive storage
  void _loadRateLimitData() {
    try {
      final savedFailedAttempts = _hiveService.get<int>(
        key: _failedAttemptsKey,
      );
      final savedLockoutUntil = _hiveService.get<String>(key: _lockoutUntilKey);

      if (savedFailedAttempts != null) {
        failedAttempts.value = savedFailedAttempts;
      }

      if (savedLockoutUntil != null) {
        final lockoutTime = DateTime.tryParse(savedLockoutUntil);
        if (lockoutTime != null && lockoutTime.isAfter(DateTime.now())) {
          lockoutUntil.value = lockoutTime;
          LoggerService.w(
            'Account is locked until $lockoutTime',
            tag: 'SignIn',
          );
        } else {
          // Lockout expired, reset
          _resetRateLimitData();
        }
      }
    } catch (e) {
      LoggerService.e('Error loading rate limit data', error: e, tag: 'SignIn');
    }
  }

  /// Save remember me preference and login timestamp
  void _saveRememberMeSession() {
    try {
      if (rememberMe.value) {
        // Save remember me preference
        _hiveService.set<bool>(key: _rememberMeKey, data: true);

        // Save current login timestamp
        _hiveService.set<String>(
          key: _lastLoginKey,
          data: DateTime.now().toIso8601String(),
        );

        LoggerService.d('Remember me session saved', tag: 'SignIn');
      } else {
        _clearRememberMe();
      }
    } catch (e) {
      LoggerService.e(
        'Error saving remember me session',
        error: e,
        tag: 'SignIn',
      );
    }
  }

  /// Clear remember me data
  void _clearRememberMe() {
    try {
      HiveService.generalBox.delete(_rememberMeKey);
      HiveService.generalBox.delete(_lastLoginKey);
      rememberMe.value = false;
      LoggerService.d('Remember me data cleared', tag: 'SignIn');
    } catch (e) {
      LoggerService.e('Error clearing remember me', error: e, tag: 'SignIn');
    }
  }

  /// Save rate limit data to Hive storage
  void _saveRateLimitData() {
    try {
      _hiveService.set<int>(
        key: _failedAttemptsKey,
        data: failedAttempts.value,
      );
      if (lockoutUntil.value != null) {
        _hiveService.set<String>(
          key: _lockoutUntilKey,
          data: lockoutUntil.value!.toIso8601String(),
        );
      }
    } catch (e) {
      LoggerService.e('Error saving rate limit data', error: e, tag: 'SignIn');
    }
  }

  /// Reset rate limit data
  void _resetRateLimitData() {
    try {
      failedAttempts.value = 0;
      lockoutUntil.value = null;
      HiveService.generalBox.delete(_failedAttemptsKey);
      HiveService.generalBox.delete(_lockoutUntilKey);
      LoggerService.d('Reset rate limit data', tag: 'SignIn');
    } catch (e) {
      LoggerService.e(
        'Error resetting rate limit data',
        error: e,
        tag: 'SignIn',
      );
    }
  }

  /// Check if account is currently locked out
  bool _isLockedOut() {
    if (lockoutUntil.value != null) {
      if (DateTime.now().isBefore(lockoutUntil.value!)) {
        final remaining = lockoutUntil.value!.difference(DateTime.now());
        final minutes = remaining.inMinutes;
        final seconds = remaining.inSeconds % 60;
        CustomToast.show(
          message:
              'Too many failed attempts. Please try again in ${minutes}m ${seconds}s',
          type: ToastType.error,
        );
        return true;
      } else {
        // Lockout expired
        _resetRateLimitData();
        return false;
      }
    }
    return false;
  }

  /// Handle failed sign in attempt
  void _handleFailedAttempt() {
    failedAttempts.value++;
    LoggerService.w('Failed attempt #${failedAttempts.value}', tag: 'SignIn');

    if (failedAttempts.value >= 5) {
      lockoutUntil.value = DateTime.now().add(const Duration(minutes: 5));
      _saveRateLimitData();
      LoggerService.w(
        'Account locked until ${lockoutUntil.value}',
        tag: 'SignIn',
      );
      CustomToast.show(
        message: 'Too many failed attempts. Account locked for 5 minutes.',
        type: ToastType.error,
      );
    } else {
      _saveRateLimitData();
      final remaining = 5 - failedAttempts.value;
      CustomToast.show(
        message: 'Invalid credentials. $remaining attempts remaining.',
        type: ToastType.error,
      );
    }
  }

  /// Toggle remember me
  void toggleRememberMe(bool value) {
    rememberMe.value = value;
    LoggerService.d('Remember me: $value', tag: 'SignIn');
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
    // Check if account is locked out
    if (_isLockedOut()) {
      return;
    }

    // Check password requirements first
    if (!isPasswordValid && passwordController.value.text.isNotEmpty) {
      isPasswordFocused.value = true;
      triggerShake();
      return;
    }

    if (!formKey.value.currentState!.validate()) {
      return;
    }

    // Check internet connectivity
    if (!ConnectivityService.to.isConnected.value) {
      CustomToast.show(
        message: 'No internet connection. Please check your connection.',
        type: ToastType.error,
        position: ToastPosition.bottom,
      );
      return;
    }

    try {
      isLoading.value = true;
      CustomLoadingOverlayWidget.show(message: 'Signing in...');

      final response = await _supabaseService.signInWithEmailPassword(
        email: emailController.value.text.trim(),
        password: passwordController.value.text,
      );

      if (response.user != null) {
        // Sign in successful - reset rate limit and save remember me session
        _resetRateLimitData();
        _saveRememberMeSession();

        LoggerService.i("Sign in with email successful", tag: 'SignIn');
        CustomLoadingOverlayWidget.hide();
        CustomToast.show(
          message: 'Successfully signed in!',
          type: ToastType.success,
        );

        // Optimize delay from 1500ms to 300ms
        await Future.delayed(const Duration(milliseconds: 300));
        Get.offAllNamed(Routes.homeRoute);
      }
    } catch (e) {
      LoggerService.e("Error signing in with email", error: e, tag: 'SignIn');
      CustomLoadingOverlayWidget.hide();

      // MEDIUM FIX #7: Handle failed attempt for rate limiting
      _handleFailedAttempt();
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    // Check internet connectivity
    if (!ConnectivityService.to.isConnected.value) {
      CustomToast.show(
        message: 'No internet connection. Please check your connection.',
        type: ToastType.error,
        position: ToastPosition.bottom,
      );
      return;
    }

    try {
      isGoogleLoading.value = true;
      CustomLoadingOverlayWidget.show(message: 'Signing in with Google...');

      final response = await _supabaseService.signInWithGoogle();

      if (response != null && response.user != null) {
        // Sign in successful - reset rate limit and save remember me session
        _resetRateLimitData();
        _saveRememberMeSession();

        LoggerService.i("Sign in with Google successful", tag: 'SignIn');
        CustomLoadingOverlayWidget.hide();
        CustomToast.show(
          message: 'Successfully signed in with Google!',
          type: ToastType.success,
        );

        // Optimize delay from 1500ms to 300ms
        await Future.delayed(const Duration(milliseconds: 300));
        Get.offAllNamed(Routes.homeRoute);
      } else {
        LoggerService.w("Google sign in cancelled", tag: 'SignIn');
        CustomLoadingOverlayWidget.hide();
      }
    } catch (e) {
      LoggerService.e("Error signing in with Google", error: e, tag: 'SignIn');
      CustomLoadingOverlayWidget.hide();
      CustomToast.show(
        message: SupabaseErrorHandler.parseError(e),
        type: ToastType.error,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }
}
