import 'package:get/get.dart';
import 'package:safe_drive/features/scanner/controllers/scanner_controller.dart';
    
class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScannerController());
  }
}
  