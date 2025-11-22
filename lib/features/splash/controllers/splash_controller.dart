import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/utils/services/hive_service.dart';
import 'package:safe_drive/utils/services/logger_service.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();

  final SupabaseService _supabaseService = SupabaseService.instance;
  final HiveService _hiveService = Get.find<HiveService>();

  // Hive keys
  static const String _rememberMeKey = 'remember_me_enabled';
  static const String _lastLoginKey = 'last_login_timestamp';

  // Session timeout duration (7 days)
  static const Duration _sessionTimeout = Duration(days: 7);

  /// Check authentication and navigate to appropriate screen
  Future<void> checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Check if remember me is enabled
      final isRememberMeEnabled = _hiveService.get<bool>(key: _rememberMeKey);

      if (isRememberMeEnabled == true) {
        // Check session timeout
        final lastLoginTimestamp = _hiveService.get<String>(key: _lastLoginKey);

        if (lastLoginTimestamp != null) {
          final lastLogin = DateTime.tryParse(lastLoginTimestamp);

          if (lastLogin != null) {
            final sessionAge = DateTime.now().difference(lastLogin);

            if (sessionAge < _sessionTimeout) {
              // Session timeout valid, check Supabase session
              final session = _supabaseService.client.auth.currentSession;

              if (session != null) {
                // Valid session - navigate to home
                LoggerService.i('Auto-login: Valid session found', tag: 'Splash');
                Get.offAllNamed(Routes.homeRoute);
                return;
              } else {
                LoggerService.d('No active Supabase session', tag: 'Splash');
              }
            } else {
              // Session expired - clear remember me data
              LoggerService.w('Session expired after 7 days', tag: 'Splash');
              _clearRememberMe();
            }
          }
        }
      }

      // No valid session - navigate to sign in
      LoggerService.d('Navigate to Sign In', tag: 'Splash');
      Get.offNamed(Routes.signInRoute);

    } catch (e) {
      LoggerService.e('Error checking auth', error: e, tag: 'Splash');
      // On error, go to sign in
      Get.offNamed(Routes.signInRoute);
    }
  }

  /// Clear remember me data
  void _clearRememberMe() {
    try {
      HiveService.generalBox.delete(_rememberMeKey);
      HiveService.generalBox.delete(_lastLoginKey);
      LoggerService.d('Remember me data cleared', tag: 'Splash');
    } catch (e) {
      LoggerService.e('Error clearing remember me', error: e, tag: 'Splash');
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkAuthAndNavigate();
  }
}
