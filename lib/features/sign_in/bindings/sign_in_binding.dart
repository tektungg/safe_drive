import 'package:get/get.dart';
import 'package:safe_drive/features/sign_in/controllers/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
  }
}
