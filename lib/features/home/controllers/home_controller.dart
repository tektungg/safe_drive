import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/widgets/custom_dialog_widget.dart';
import 'package:safe_drive/shared/widgets/custom_toast_widget.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  final SupabaseService _supabaseService = SupabaseService.instance;

  // User data
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _supabaseService.currentUser;
    if (user != null) {
      userName.value = user.userMetadata?['name'] ?? 'User';
      userEmail.value = user.email ?? '';
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  Future<void> signOut() async {
    CustomDialogWidget.show(
      type: DialogType.question,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      primaryButtonText: 'Sign Out',
      secondaryButtonText: 'Cancel',
      primaryButtonColor: ColorStyle.danger,
      onPrimaryPressed: () async {
        CustomDialogWidget.close();
        await _supabaseService.signOut();
        Get.offAllNamed(Routes.signInRoute);
        CustomToast.show(
          message: "Signed out successfully",
          type: ToastType.success,
        );
      },
    );
  }
}
