import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/utils/services/auth_service.dart';
import 'package:safe_drive/utils/services/logger_service.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();

  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Check authentication and navigate to appropriate screen
  Future<void> checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Check if remember me is enabled
      final isRememberMeEnabled = AuthService.isRememberMeEnabled();

      if (isRememberMeEnabled) {
        // Validate both local session timeout AND Supabase token
        final isSessionValid = AuthService.isSessionValid();

        if (isSessionValid) {
          // Local session is valid, now check Supabase session
          final session = _supabaseService.client.auth.currentSession;

          if (session != null) {
            // Validate Supabase token expiration
            final isTokenValid = AuthService.isSupabaseTokenValid(
              session.expiresAt,
            );

            if (isTokenValid) {
              // Both local session and Supabase token are valid
              LoggerService.i(
                'Auto-login: Valid session and token found',
                tag: 'Splash',
              );
              Get.offAllNamed(Routes.homeRoute);
              return;
            } else {
              // Token expired
              LoggerService.w('Supabase token expired', tag: 'Splash');
              AuthService.clearRememberMeData();
            }
          } else {
            LoggerService.d('No active Supabase session', tag: 'Splash');
            AuthService.clearRememberMeData();
          }
        } else {
          // Local session expired (7 days timeout)
          LoggerService.w('Local session expired after 7 days', tag: 'Splash');
          AuthService.clearRememberMeData();
        }
      }

      // No valid session - navigate to sign in
      LoggerService.d('Navigate to Sign In', tag: 'Splash');
      Get.offNamed(Routes.signInRoute);
    } catch (e) {
      LoggerService.e('Error checking auth', error: e, tag: 'Splash');
      // On error, clear data and go to sign in
      AuthService.clearRememberMeData();
      Get.offNamed(Routes.signInRoute);
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkAuthAndNavigate();
  }
}
