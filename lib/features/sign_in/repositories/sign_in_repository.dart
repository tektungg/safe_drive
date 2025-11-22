import 'package:dio/dio.dart';
import 'package:safe_drive/constants/api_constant.dart';
import 'package:safe_drive/features/sign_in/models/sign_in_model.dart';
import 'package:safe_drive/utils/services/api_service.dart';
import 'package:safe_drive/utils/services/logger_service.dart';

/// Repository for Sign In feature using alternative API (phone-based login)
///
/// **IMPORTANT NOTE:**
/// This repository is currently **NOT USED** in the Sign In feature.
/// The current implementation uses SupabaseService directly for authentication
/// via email/password and Google OAuth.
///
/// This repository is kept for:
/// 1. Future implementation of phone-based login
/// 2. Alternative authentication method
/// 3. Backward compatibility if needed
///
/// If you want to use this repository:
/// 1. Inject it into SignInController
/// 2. Call `SignInRepository.login()` method
/// 3. Handle the SignInModel response appropriately
///
/// If this repository will never be used, consider deleting it to reduce
/// code complexity and maintenance burden.
class SignInRepository {
  SignInRepository._();

  /// Phone-based login using custom API
  ///
  /// This method is an alternative to Supabase authentication.
  /// Uses the ApiService to make HTTP requests to the custom backend.
  ///
  /// **Parameters:**
  /// - [phoneNumber]: User's phone number
  /// - [password]: User's password
  /// - [fcmToken]: Firebase Cloud Messaging token for push notifications
  ///
  /// **Returns:**
  /// SignInModel containing access token and user data
  ///
  /// **Throws:**
  /// - DioException: Network or HTTP errors
  /// - Exception: Other errors during login process
  static Future<SignInModel> login(
    String phoneNumber,
    String password,
    String? fcmToken,
  ) async {
    try {
      final response = await ApiService.post(
        ApiConstant.login,
        data: {
          "phone": phoneNumber,
          "password": password,
          "fcm_token": fcmToken,
        },
      );
      return SignInModel.fromJson(response.data);
    } on DioException {
      rethrow;
    } catch (e) {
      LoggerService.e("Error during login", error: e, tag: 'SignInRepository');
      throw Exception(e.toString());
    }
  }
}
