import 'package:get/get.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';
import 'package:venturo_api_manager/loggers/logger.dart';

class SignUpController extends GetxController {
  static SignUpController get to => Get.find();

  final SupabaseService _supabaseService = SupabaseService.instance;

  // Loading state
  final RxBool isLoading = false.obs;

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final response = await _supabaseService.signInWithGoogle();

      if (response != null && response.user != null) {
        logger.i("Sign up with Google successful");
        Get.snackbar(
          'Success',
          'Successfully signed in with Google!',
          snackPosition: SnackPosition.BOTTOM,
        );

        // TODO: Navigate to home screen or next screen
        // Get.offAllNamed(Routes.HOME);
      } else {
        logger.w("Google sign in cancelled");
      }
    } catch (e) {
      logger.e("Error signing in with Google: $e");
      Get.snackbar(
        'Error',
        'Failed to sign in with Google: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
