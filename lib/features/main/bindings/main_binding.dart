import 'package:get/get.dart';
import 'package:safe_drive/features/main/controllers/main_controller.dart';

/// Binding for main navigation feature
///
/// Initializes the MainController when the main navigation screen is loaded.
class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
  }
}
