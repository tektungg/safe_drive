import 'package:get/get.dart';
import 'package:safe_drive/features/home/controllers/home_controller.dart';
    
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
  