import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/constants/asset_constant.dart';
import 'package:safe_drive/features/sign_in/controllers/sign_in_controller.dart';

class SignInActionButtonComponent extends GetView<SignInController> {
  const SignInActionButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),

        // Sign In Button
        Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.signInWithEmail(),
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
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )),

        SizedBox(height: 24.h),

        // Divider with "OR"
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'OR',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),

        SizedBox(height: 24.h),

        // Google Sign In Button
        Obx(() => ElevatedButton.icon(
              onPressed: controller.isGoogleLoading.value
                  ? null
                  : () => controller.signInWithGoogle(),
              icon: controller.isGoogleLoading.value
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    )
                  : Image.asset(
                      AssetConstants.iconGoogle,
                      width: 24.w,
                      height: 24.h,
                    ),
              label: Text(
                controller.isGoogleLoading.value
                    ? 'Signing in...'
                    : 'Continue with Google',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                elevation: 1,
              ),
            )),
      ],
    );
  }
}
