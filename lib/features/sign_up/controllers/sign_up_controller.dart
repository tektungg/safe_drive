import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/utils/functions/dialog_utils_function.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';
import 'package:venturo_api_manager/loggers/logger.dart';

class SignUpController extends GetxController {
  static SignUpController get to => Get.find();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '391478746861-d696mferfehedt5fjoemp9vqh5o8kqj3.apps.googleusercontent.com', // Add your Web Client ID here for iOS
    serverClientId:
        '391478746861-d696mferfehedt5fjoemp9vqh5o8kqj3.apps.googleusercontent.com', // Add your Web Client ID here for Android
  );

  RxBool isLoading = false.obs;

  Future<void> signUpWithGoogle() async {
    try {
      isLoading.value = true;
      unawaited(DialogUtilsFunction.showGlobalLoading());

      // Sign out from Google first to allow account selection
      await _googleSignIn.signOut();

      // Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        Get.back(); // Close loading dialog
        isLoading.value = false;
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Google sign in failed - tokens are null');
      }

      // Sign in to Supabase using Google credentials
      final AuthResponse response =
          await SupabaseService.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      Get.back(); // Close loading dialog

      if (response.user != null) {
        logger.i('User signed in: ${response.user!.email}');

        // Show success message
        Get.snackbar(
          'Success',
          'Successfully signed in with Google',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Navigate to home screen
        Get.offAllNamed(Routes.homeRoute);
      }
    } on AuthException catch (e) {
      Get.back(); // Close loading dialog
      logger.e('Auth error: ${e.message}');

      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      logger.e('Error signing in with Google: $e');

      Get.snackbar(
        'Error',
        'Failed to sign in with Google. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _googleSignIn.disconnect();
    super.onClose();
  }
}
