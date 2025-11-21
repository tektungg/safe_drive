import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/sign_up/controllers/sign_up_controller.dart';
import 'package:safe_drive/shared/widgets/custom_button_widget.dart';

class SignUpActionButtonComponent extends GetView<SignUpController> {
  const SignUpActionButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        Obx(() => CustomButtonWidget(
              text: 'Sign Up',
              isLoading: controller.isLoading.value,
              onPressed: () => controller.signUpWithEmail(),
            )),
      ],
    );
  }
}
