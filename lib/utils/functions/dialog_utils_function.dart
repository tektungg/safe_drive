import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtilsFunction {
  static Future<void> showGlobalLoading() async {
    return Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void closeGlobalLoading() {
    if (Get.isDialogOpen ?? false) Get.back();
  }
}
