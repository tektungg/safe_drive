import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/features/sign_in/repositories/sign_in_repository.dart';
import 'package:safe_drive/utils/functions/dialog_utils_function.dart';
import 'package:safe_drive/utils/services/amplitude_services.dart';
import 'package:safe_drive/utils/services/hive_service.dart';

class SignInController extends GetxController {
  static SignInController get to => Get.find();

  Rx<GlobalKey<FormState>> formKeyt = GlobalKey<FormState>().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  Future<void> login() async {
    try {
      /* Kondisi untuk menghindari bug unlimited loading */
      if ((Get.isDialogOpen ?? false) || Get.isSnackbarOpen) {
        return;
      }
      if (!formKeyt.value.currentState!.validate()) return;

      unawaited(DialogUtilsFunction.showGlobalLoading());
      final phoneNumberInput =
          phoneController.value.text.trim().replaceAll("-", "");
      final password = passwordController.value.text.trim();
      final response = await SignInRepository.login(
        phoneNumberInput,
        password,
        "",
      );
      await HiveService.setBearer(response.data?.accessToken ?? "");
      await AmplitudeServices.instance.setUserIdentify(id: phoneNumberInput);

      AmplitudeServices.instance.logEventCostume(
        logName: "login_success",
        eventProperties: {
          "phone": phoneNumberInput,
          "role": response.data?.user?.role,
        },
      );

      DialogUtilsFunction.closeGlobalLoading();

      await Get.offAllNamed(
        Routes.crudRoute,
        arguments: {"is_warga": response.data?.user?.role == "WARGA"},
      );
    } catch (e) {
      AmplitudeServices.instance.logEventCostume(
        logName: "login_failed",
      );

      DialogUtilsFunction.closeGlobalLoading();
      Get.snackbar("Login Gagal", "Phone atau Password salah");
    }
  }
}
