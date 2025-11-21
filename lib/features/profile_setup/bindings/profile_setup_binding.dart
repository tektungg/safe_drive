import 'package:get/get.dart';
import 'package:safe_drive/features/profile_setup/controllers/profile_setup_controller.dart';

class ProfileSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSetupController>(() => ProfileSetupController());
  }
}
