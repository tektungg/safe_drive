import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/utils/services/hive_service.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();

  void toDashboard() {
    Future.delayed(const Duration(seconds: 2), () {
      if (HiveService.getBearer() != null) {
        Get.offAllNamed(Routes.crudRoute);
      } else {
        Get.offNamed(Routes.signInRoute);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    toDashboard();
  }
}
