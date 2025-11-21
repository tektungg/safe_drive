import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/sign_up/controllers/sign_up_controller.dart';

class SignUpActionButtonComponent extends GetView<SignUpController> {
  const SignUpActionButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.signUpWithEmail(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              child: controller.isLoading.value
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )),
      ],
    );
  }
}
