import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/constants/asset_constant.dart';
import 'package:safe_drive/features/sign_in/controllers/sign_in_controller.dart';
import 'package:safe_drive/shared/widgets/custom_button_widget.dart';
import 'package:safe_drive/shared/widgets/custom_divider_widget.dart';

class SignInActionButtonComponent extends GetView<SignInController> {
  const SignInActionButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),

        // Sign In Button
        Obx(() => CustomButtonWidget(
              text: 'Sign In',
              isLoading: controller.isLoading.value,
              onPressed: () => controller.signInWithEmail(),
            )),

        SizedBox(height: 24.h),

        // Divider with "OR"
        const CustomDividerWidget(text: 'OR'),

        SizedBox(height: 24.h),

        // Google Sign In Button
        Obx(() => CustomButtonWidget(
              text: controller.isGoogleLoading.value
                  ? 'Signing in...'
                  : 'Continue with Google',
              isLoading: controller.isGoogleLoading.value,
              backgroundColor: Colors.white,
              textColor: Colors.black87,
              borderColor: Colors.grey[300],
              elevation: 1,
              leadingIcon: controller.isGoogleLoading.value
                  ? null
                  : Image.asset(
                      AssetConstants.iconGoogle,
                      width: 24.w,
                      height: 24.h,
                    ),
              onPressed: () => controller.signInWithGoogle(),
            )),
      ],
    );
  }
}
