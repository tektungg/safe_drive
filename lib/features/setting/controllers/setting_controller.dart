import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/utils/services/logger_service.dart';
import 'package:safe_drive/shared/widgets/custom_dialog_widget.dart';
import 'package:safe_drive/shared/widgets/custom_toast_widget.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';
import 'package:safe_drive/shared/models/user_data_model.dart';

class SettingController extends GetxController {
  static SettingController get to => Get.find();

  // Services
  final _supabaseService = SupabaseService.instance;

  // User Information
  final Rx<UserDataModel?> userData = Rx<UserDataModel?>(null);
  final RxString userName = 'User'.obs;
  final RxString userEmail = ''.obs;
  final RxString userAvatar = ''.obs;

  // App Settings
  final RxBool notificationsEnabled = true.obs;
  final RxBool soundEnabled = true.obs;
  final RxBool locationEnabled = true.obs;

  // App Info
  final RxString appVersion = '1.0.0'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadSettings();
  }

  /// Load user data from Supabase
  Future<void> _loadUserData() async {
    try {
      // Get user data from Supabase
      final user = _supabaseService.getUserData();

      if (user != null) {
        userData.value = user;
        userName.value = user.displayName;
        userEmail.value = user.email;
        userAvatar.value = user.avatarUrl ?? '';

        LoggerService.info(
          'User data loaded: ${user.displayName} (${user.email})',
          tag: 'Setting',
        );
      } else {
        LoggerService.warning('No user data found', tag: 'Setting');

        // Set default values if no user
        userName.value = 'Guest';
        userEmail.value = 'No account';
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to load user data',
        error: e,
        stackTrace: stackTrace,
        tag: 'Setting',
      );

      // Set default values on error
      userName.value = 'Guest';
      userEmail.value = 'No account';
    }
  }

  /// Refresh user data from Supabase
  Future<void> refreshUserData() async {
    try {
      final user = await _supabaseService.refreshUserData();

      if (user != null) {
        userData.value = user;
        userName.value = user.displayName;
        userEmail.value = user.email;
        userAvatar.value = user.avatarUrl ?? '';

        LoggerService.info(
          'User data refreshed: ${user.displayName} (${user.email})',
          tag: 'Setting',
        );

        CustomToast.show(message: 'Profile updated', type: ToastType.success);
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to refresh user data',
        error: e,
        stackTrace: stackTrace,
        tag: 'Setting',
      );
    }
  }

  /// Load app settings
  Future<void> _loadSettings() async {
    try {
      // TODO: Load settings from local storage
      LoggerService.info('Settings loaded', tag: 'Setting');
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to load settings',
        error: e,
        stackTrace: stackTrace,
        tag: 'Setting',
      );
    }
  }

  /// Navigate to Edit Profile
  void navigateToEditProfile() {
    LoggerService.info('Navigate to edit profile', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Edit profile feature coming soon',
      type: ToastType.info,
    );
  }

  /// Navigate to Personal Info
  void navigateToPersonalInfo() {
    LoggerService.info('Navigate to personal info', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Personal info feature coming soon',
      type: ToastType.info,
    );
  }

  /// Navigate to Change Password
  void navigateToChangePassword() {
    LoggerService.info('Navigate to change password', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Change password feature coming soon',
      type: ToastType.info,
    );
  }

  /// Navigate to Privacy & Security
  void navigateToPrivacySecurity() {
    LoggerService.info('Navigate to privacy & security', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Privacy & security feature coming soon',
      type: ToastType.info,
    );
  }

  /// Toggle notifications
  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    LoggerService.info(
      'Notifications ${value ? "enabled" : "disabled"}',
      tag: 'Setting',
    );
    // TODO: Save to local storage
    CustomToast.show(
      message: 'Notifications ${value ? "enabled" : "disabled"}',
      type: ToastType.success,
    );
  }

  /// Toggle sound effects
  void toggleSound(bool value) {
    soundEnabled.value = value;
    LoggerService.info(
      'Sound ${value ? "enabled" : "disabled"}',
      tag: 'Setting',
    );
    // TODO: Save to local storage
    CustomToast.show(
      message: 'Sound ${value ? "enabled" : "disabled"}',
      type: ToastType.success,
    );
  }

  /// Navigate to Language settings
  void navigateToLanguage() {
    LoggerService.info('Navigate to language', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Language feature coming soon',
      type: ToastType.info,
    );
  }

  /// Navigate to Drowsiness Settings
  void navigateToDrowsinessSettings() {
    LoggerService.info('Navigate to drowsiness settings', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Drowsiness settings feature coming soon',
      type: ToastType.info,
    );
  }

  /// Navigate to Traffic Sign Settings
  void navigateToTrafficSignSettings() {
    LoggerService.info('Navigate to traffic sign settings', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Traffic sign settings feature coming soon',
      type: ToastType.info,
    );
  }

  /// Toggle location services
  void toggleLocation(bool value) {
    locationEnabled.value = value;
    LoggerService.info(
      'Location ${value ? "enabled" : "disabled"}',
      tag: 'Setting',
    );
    // TODO: Save to local storage and request permission if needed
    CustomToast.show(
      message: 'Location ${value ? "enabled" : "disabled"}',
      type: ToastType.success,
    );
  }

  /// Navigate to Help & FAQ
  void navigateToHelp() {
    LoggerService.info('Navigate to help', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Help & FAQ feature coming soon',
      type: ToastType.info,
    );
  }

  /// Navigate to Feedback
  void navigateToFeedback() {
    LoggerService.info('Navigate to feedback', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Feedback feature coming soon',
      type: ToastType.info,
    );
  }

  /// Rate the app
  void rateApp() {
    LoggerService.info('Rate app', tag: 'Setting');
    // TODO: Open app store rating
    CustomToast.show(
      message: 'Rate app feature coming soon',
      type: ToastType.info,
    );
  }

  /// Navigate to About
  void navigateToAbout() {
    LoggerService.info('Navigate to about', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'About feature coming soon',
      type: ToastType.info,
    );
  }

  /// Navigate to Terms & Conditions
  void navigateToTerms() {
    LoggerService.info('Navigate to terms', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Terms & Conditions feature coming soon',
      type: ToastType.info,
    );
  }

  /// Navigate to Privacy Policy
  void navigateToPrivacyPolicy() {
    LoggerService.info('Navigate to privacy policy', tag: 'Setting');
    // TODO: Implement navigation
    CustomToast.show(
      message: 'Privacy Policy feature coming soon',
      type: ToastType.info,
    );
  }

  /// Logout
  void logout() {
    CustomDialogWidget.show(
      type: DialogType.warning,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      primaryButtonText: 'Logout',
      secondaryButtonText: 'Cancel',
      primaryButtonColor: ColorStyle.danger,
      onPrimaryPressed: () => _performLogout(),
    );
  }

  /// Perform logout action
  Future<void> _performLogout() async {
    try {
      // Sign out from Supabase
      await _supabaseService.signOut();

      // Clear user data
      userData.value = null;
      userName.value = 'Guest';
      userEmail.value = 'No account';
      userAvatar.value = '';

      LoggerService.info('User logged out successfully', tag: 'Setting');

      CustomToast.show(
        message: 'Logged out successfully',
        type: ToastType.success,
      );

      Get.offAllNamed(Routes.signInRoute);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to logout',
        error: e,
        stackTrace: stackTrace,
        tag: 'Setting',
      );
      CustomToast.show(message: 'Failed to logout', type: ToastType.error);
    }
  }
}
