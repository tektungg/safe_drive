import "package:get/get.dart";
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
}
