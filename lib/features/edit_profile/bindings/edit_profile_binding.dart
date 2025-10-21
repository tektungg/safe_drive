import 'package:get/get.dart';
import 'package:safe_drive/features/edit_profile/controllers/edit_profile_controller.dart';
    
class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController());
  }
}
  