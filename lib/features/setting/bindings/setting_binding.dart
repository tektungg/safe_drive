import 'package:get/get.dart';
import 'package:safe_drive/features/setting/controllers/setting_controller.dart';
    
class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
  