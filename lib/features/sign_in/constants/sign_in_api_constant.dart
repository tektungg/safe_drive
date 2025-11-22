/// Constants for Sign In feature API endpoints
///
/// This class contains all API endpoint paths used in the Sign In feature.
/// Centralized API management ensures consistency and easier maintenance.
class SignInApiConstant {
  SignInApiConstant._();

  // Note: Current sign in implementation uses Supabase authentication
  // API constants here are for alternative/future API implementations
  // The phone-based login endpoint is defined in main ApiConstant.login

  /// Alternative phone-based login endpoint
  /// Used by SignInRepository (currently not in use)
  static const String phoneLogin = '/auth/login';

  /// Email-based login endpoint (if using custom API instead of Supabase)
  static const String emailLogin = '/auth/email-login';

  /// Google OAuth callback endpoint (if using custom API)
  static const String googleAuthCallback = '/auth/google/callback';
}
