import "package:get/get.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:safe_drive/env/env.dart";
import "package:venturo_api_manager/loggers/logger.dart";

class SupabaseService extends GetxService {
  static SupabaseService get instance => Get.find();

  late final SupabaseClient client;

  Future<SupabaseService> init() async {
    try {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
      );

      client = Supabase.instance.client;
      logger.i("Supabase initialized successfully");

      return this;
    } catch (e) {
      logger.e("Error initializing Supabase: $e");
      rethrow;
    }
  }

  // Get current user
  User? get currentUser => client.auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );

      logger.i("Sign up with email successful: ${response.user?.email}");
      return response;
    } catch (e) {
      logger.e("Error during email sign up: $e");
      rethrow;
    }
  }

  // Update user profile (name and avatar)
  Future<UserResponse> updateUserProfile({
    String? name,
    String? avatarUrl,
    String? picture,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (name != null) data['full_name'] = name;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;
      if (picture != null) data['picture'] = picture;

      final response = await client.auth.updateUser(
        UserAttributes(data: data),
      );

      logger.i("User profile updated successfully");
      return response;
    } catch (e) {
      logger.e("Error updating user profile: $e");
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      logger.i("Sign in with email successful: ${response.user?.email}");
      return response;
    } catch (e) {
      logger.e("Error during email sign in: $e");
      rethrow;
    }
  }

  // Sign in with Google
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      // Web Client ID dari Google Console (untuk iOS gunakan iOS Client ID)
      const webClientId =
          '391478746861-2b15soo5o1tp8vu8p8adfgc2m2du4ckm.apps.googleusercontent.com';

      // iOS Client ID dari Info.plist
      const iosClientId =
          '391478746861-2dv6s327qvamnphnvpngat2lg98o8c3b.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        logger.w("Google Sign In cancelled by user");
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        logger.e("No Access Token found");
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        logger.e("No ID Token found");
        throw 'No ID Token found.';
      }

      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      logger.i("Google Sign In successful: ${response.user?.email}");
      return response;
    } catch (e) {
      logger.e("Error during Google Sign In: $e");
      rethrow;
    }
  }
}
