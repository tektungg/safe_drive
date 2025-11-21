import 'package:supabase_flutter/supabase_flutter.dart';

/// A utility class for handling Supabase authentication errors.
///
/// This class converts technical Supabase error codes into user-friendly
/// messages that can be displayed in toast notifications.
///
/// ## Usage Example
///
/// ```dart
/// try {
///   await supabase.auth.signInWithPassword(...);
/// } on AuthException catch (e) {
///   final message = SupabaseErrorHandler.getErrorMessage(e);
///   CustomToast.show(message: message, type: ToastType.error);
/// } catch (e) {
///   final message = SupabaseErrorHandler.parseError(e);
///   CustomToast.show(message: message, type: ToastType.error);
/// }
/// ```
class SupabaseErrorHandler {
  SupabaseErrorHandler._();

  /// Maps Supabase error codes to user-friendly messages.
  static const Map<String, String> _errorMessages = {
    // Authentication errors
    'invalid_credentials': 'Invalid email or password. Please try again.',
    'email_exists': 'This email is already registered. Try signing in instead.',
    'user_already_exists': 'An account with this email already exists.',
    'email_not_confirmed': 'Please verify your email before signing in.',
    'email_address_invalid': 'Please enter a valid email address.',
    'weak_password': 'Password is too weak. Please use a stronger password.',
    'same_password':
        'New password must be different from your current password.',

    // Account status errors
    'user_not_found': 'Account not found. Please check your credentials.',
    'user_banned': 'Your account has been suspended. Please contact support.',
    'signup_disabled': 'New registrations are currently disabled.',

    // Provider errors
    'email_provider_disabled': 'Email sign-in is currently unavailable.',
    'phone_provider_disabled': 'Phone sign-in is currently unavailable.',
    'oauth_provider_not_supported': 'This sign-in method is not available.',
    'provider_disabled': 'This sign-in method is currently disabled.',
    'anonymous_provider_disabled': 'Anonymous sign-in is not available.',

    // Session errors
    'session_expired': 'Your session has expired. Please sign in again.',
    'session_not_found': 'Session not found. Please sign in again.',
    'refresh_token_not_found': 'Session expired. Please sign in again.',
    'refresh_token_already_used': 'Session invalid. Please sign in again.',

    // OTP/Magic link errors
    'otp_expired': 'Verification code has expired. Please request a new one.',
    'otp_disabled': 'This verification method is not available.',

    // Rate limiting
    'over_request_rate_limit':
        'Too many attempts. Please wait a moment and try again.',
    'over_email_send_rate_limit':
        'Too many emails sent. Please wait before trying again.',
    'over_sms_send_rate_limit':
        'Too many SMS sent. Please wait before trying again.',

    // MFA errors
    'mfa_verification_failed': 'Incorrect verification code. Please try again.',
    'mfa_challenge_expired': 'Verification expired. Please request a new code.',
    'insufficient_aal': 'Additional verification required.',

    // Phone errors
    'phone_exists': 'This phone number is already registered.',
    'phone_not_confirmed': 'Please verify your phone number.',
    'sms_send_failed': 'Failed to send SMS. Please try again.',

    // OAuth errors
    'bad_oauth_callback': 'Sign-in was interrupted. Please try again.',
    'bad_oauth_state': 'Sign-in failed. Please try again.',

    // CAPTCHA
    'captcha_failed': 'CAPTCHA verification failed. Please try again.',

    // Invite
    'invite_not_found': 'Invitation has expired or already been used.',

    // Reauthentication
    'reauthentication_needed': 'Please verify your identity to continue.',
    'reauthentication_not_valid': 'Verification failed. Please try again.',

    // Flow state
    'flow_state_expired': 'Sign-in session expired. Please try again.',
    'flow_state_not_found': 'Sign-in session not found. Please try again.',

    // Identity
    'identity_already_exists': 'This account is already linked.',
    'identity_not_found': 'Linked account not found.',
    'single_identity_not_deletable': 'Cannot remove your only sign-in method.',
    'email_conflict_identity_not_deletable':
        'Cannot unlink this account due to email conflict.',

    // SSO/SAML
    'sso_provider_not_found': 'SSO provider not configured.',
    'saml_idp_not_found': 'SSO provider not found.',
    'saml_relay_state_expired': 'SSO session expired. Please try again.',

    // General errors
    'bad_json': 'Invalid request. Please try again.',
    'bad_jwt': 'Authentication error. Please sign in again.',
    'validation_failed': 'Invalid input. Please check your information.',
    'request_timeout': 'Request timed out. Please try again.',
    'conflict': 'A conflict occurred. Please try again.',
    'unexpected_failure': 'Something went wrong. Please try again later.',
    'no_authorization': 'Please sign in to continue.',
    'not_admin': 'You do not have permission to perform this action.',
  };

  /// Gets a user-friendly error message from an [AuthException].
  ///
  /// Returns a readable message based on the error code.
  static String getErrorMessage(AuthException exception) {
    final code = exception.code;

    if (code != null && _errorMessages.containsKey(code)) {
      return _errorMessages[code]!;
    }

    // Fallback to parsing the message if code is not recognized
    return _parseAuthExceptionMessage(exception.message);
  }

  /// Parses any error and returns a user-friendly message.
  ///
  /// This method handles both [AuthException] and generic exceptions.
  static String parseError(dynamic error) {
    if (error is AuthException) {
      return getErrorMessage(error);
    }

    if (error is PostgrestException) {
      return _parsePostgrestError(error);
    }

    final errorString = error.toString().toLowerCase();

    // Check for common error patterns
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('socket')) {
      return 'No internet connection. Please check your network.';
    }

    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    if (errorString.contains('cancelled') || errorString.contains('canceled')) {
      return 'Operation was cancelled.';
    }

    return 'Something went wrong. Please try again.';
  }

  /// Parses PostgrestException for database errors.
  static String _parsePostgrestError(PostgrestException error) {
    final code = error.code;

    switch (code) {
      case '23505': // unique_violation
        return 'This record already exists.';
      case '23503': // foreign_key_violation
        return 'Cannot complete this action due to related data.';
      case '42501': // insufficient_privilege
        return 'You do not have permission to perform this action.';
      case 'PGRST301': // jwt expired
        return 'Session expired. Please sign in again.';
      default:
        return 'A database error occurred. Please try again.';
    }
  }

  /// Parses the raw exception message for fallback handling.
  static String _parseAuthExceptionMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('invalid login credentials') ||
        lowerMessage.contains('invalid credentials')) {
      return 'Invalid email or password. Please try again.';
    }

    if (lowerMessage.contains('email not confirmed')) {
      return 'Please verify your email before signing in.';
    }

    if (lowerMessage.contains('user not found')) {
      return 'Account not found. Please check your credentials.';
    }

    if (lowerMessage.contains('email already registered') ||
        lowerMessage.contains('already been registered')) {
      return 'This email is already registered. Try signing in instead.';
    }

    if (lowerMessage.contains('password')) {
      return 'Password does not meet requirements.';
    }

    if (lowerMessage.contains('rate limit') ||
        lowerMessage.contains('too many requests')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }

    if (lowerMessage.contains('network') ||
        lowerMessage.contains('connection')) {
      return 'No internet connection. Please check your network.';
    }

    // Return a generic message if no pattern matches
    return 'Something went wrong. Please try again.';
  }

  /// Checks if the error is a network-related error.
  static bool isNetworkError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('socket') ||
        errorString.contains('timeout');
  }

  /// Checks if the error requires the user to re-authenticate.
  static bool requiresReauth(dynamic error) {
    if (error is AuthException) {
      final code = error.code;
      return code == 'session_expired' ||
          code == 'session_not_found' ||
          code == 'refresh_token_not_found' ||
          code == 'refresh_token_already_used' ||
          code == 'bad_jwt';
    }
    return false;
  }
}
