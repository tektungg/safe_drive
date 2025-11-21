import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/constants/asset_constant.dart';
import 'package:safe_drive/features/sign_in/controllers/sign_in_controller.dart';
import 'package:safe_drive/shared/widgets/custom_app_bar_widget.dart';
import 'package:safe_drive/shared/widgets/custom_text_editing_widget.dart';

class SignInScreen extends GetView<SignInController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Sign In',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: controller.formKey.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                SizedBox(height: 40.h),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 60.h),

                // Email Input Field
                CustomTextEditingWidget(
                  label: 'Email',
                  controller: controller.emailController.value,
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 12.w,
                  ),
                  validator: controller.validateEmail,
                ),

                SizedBox(height: 16.h),

                // Password Input Field
                CustomTextEditingWidget(
                  label: 'Password',
                  controller: controller.passwordController.value,
                  hint: 'Enter your password',
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 12.w,
                  ),
                  validator: controller.validatePassword,
                ),

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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.grey),
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

                SizedBox(height: 40.h),

                // Don't have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.signUpRoute);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
