import 'package:get/get.dart';
import 'package:safe_drive/constants/hive_constant.dart';
import 'package:safe_drive/utils/services/hive_service.dart';
import 'package:safe_drive/utils/services/logger_service.dart';

/// A service for handling shared authentication utilities.
///
/// This service provides centralized methods for managing authentication-related
/// data stored in Hive, including remember me preferences, session timestamps,
/// and rate limiting data.
///
/// ## Features
/// - Clear remember me data
/// - Session timeout validation
/// - Supabase token expiration validation
/// - Consistent HiveService usage
///
/// ## Usage Examples
///
/// ### Clear remember me data
/// ```dart
/// AuthService.clearRememberMeData();
/// ```
///
/// ### Validate session timeout
/// ```dart
/// final isValid = AuthService.isSessionValid();
/// if (isValid) {
///   // Session is still valid
/// }
/// ```
///
/// ### Validate Supabase token
/// ```dart
/// final isValid = AuthService.isSupabaseTokenValid(session);
/// if (isValid) {
///   // Token is still valid
/// }
/// ```
class AuthService {
  AuthService._();

  static final HiveService _hiveService = Get.find<HiveService>();

  /// Session timeout duration (7 days)
  static const Duration sessionTimeout = Duration(days: 7);

  /// Clear remember me data from Hive storage
  ///
  /// This removes both the remember me preference and last login timestamp.
  /// Used when session expires or user signs out.
  static void clearRememberMeData() {
    try {
      HiveService.generalBox.delete(HiveConstant.rememberMeKey);
      HiveService.generalBox.delete(HiveConstant.lastLoginKey);
      LoggerService.d('Remember me data cleared', tag: 'AuthService');
    } catch (e) {
      LoggerService.e(
        'Error clearing remember me data',
        error: e,
        tag: 'AuthService',
      );
    }
  }

  /// Clear rate limiting data from Hive storage
  ///
  /// This removes both failed attempts count and lockout timestamp.
  /// Used when user successfully signs in or lockout expires.
  static void clearRateLimitData() {
    try {
      HiveService.generalBox.delete(HiveConstant.failedAttemptsKey);
      HiveService.generalBox.delete(HiveConstant.lockoutUntilKey);
      LoggerService.d('Rate limit data cleared', tag: 'AuthService');
    } catch (e) {
      LoggerService.e(
        'Error clearing rate limit data',
        error: e,
        tag: 'AuthService',
      );
    }
  }

  /// Check if the session is still valid based on last login timestamp
  ///
  /// Returns `true` if session age is less than [sessionTimeout],
  /// `false` otherwise or if timestamp is invalid.
  static bool isSessionValid() {
    try {
      final lastLoginTimestamp = _hiveService.get<String>(
        key: HiveConstant.lastLoginKey,
      );

      if (lastLoginTimestamp == null) {
        return false;
      }

      final lastLogin = DateTime.tryParse(lastLoginTimestamp);
      if (lastLogin == null) {
        return false;
      }

      final sessionAge = DateTime.now().difference(lastLogin);
      return sessionAge < sessionTimeout;
    } catch (e) {
      LoggerService.e(
        'Error checking session validity',
        error: e,
        tag: 'AuthService',
      );
      return false;
    }
  }

  /// Check if Supabase token is still valid
  ///
  /// Validates the token expiration time to ensure it hasn't expired.
  /// Returns `true` if token is valid, `false` otherwise.
  ///
  /// [expiresAt] The expiration timestamp from Supabase session
  static bool isSupabaseTokenValid(int? expiresAt) {
    if (expiresAt == null) {
      return false;
    }

    try {
      // Convert Unix timestamp to DateTime
      final expirationTime = DateTime.fromMillisecondsSinceEpoch(
        expiresAt * 1000,
      );

      // Check if token hasn't expired
      return DateTime.now().isBefore(expirationTime);
    } catch (e) {
      LoggerService.e(
        'Error checking token validity',
        error: e,
        tag: 'AuthService',
      );
      return false;
    }
  }

  /// Get the remember me preference
  ///
  /// Returns `true` if remember me is enabled, `false` otherwise.
  static bool isRememberMeEnabled() {
    try {
      final isEnabled = _hiveService.get<bool>(key: HiveConstant.rememberMeKey);
      return isEnabled ?? false;
    } catch (e) {
      LoggerService.e(
        'Error getting remember me preference',
        error: e,
        tag: 'AuthService',
      );
      return false;
    }
  }

  /// Save remember me preference and login timestamp
  ///
  /// [enabled] Whether remember me is enabled
  static void saveRememberMeSession(bool enabled) {
    try {
      if (enabled) {
        _hiveService.set<bool>(key: HiveConstant.rememberMeKey, data: true);
        _hiveService.set<String>(
          key: HiveConstant.lastLoginKey,
          data: DateTime.now().toIso8601String(),
        );
        LoggerService.d('Remember me session saved', tag: 'AuthService');
      } else {
        clearRememberMeData();
      }
    } catch (e) {
      LoggerService.e(
        'Error saving remember me session',
        error: e,
        tag: 'AuthService',
      );
    }
  }
}
