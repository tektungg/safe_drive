import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  final SupabaseService _supabaseService = SupabaseService.instance;

  Future<void> signOut() async {
    await _supabaseService.signOut();
    Get.offAllNamed(Routes.signInRoute);
  }
}
