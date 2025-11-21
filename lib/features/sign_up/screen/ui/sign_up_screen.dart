import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/sign_up/controllers/sign_up_controller.dart';
import 'package:safe_drive/shared/widgets/custom_app_bar_widget.dart';
import 'package:safe_drive/shared/widgets/custom_text_editing_widget.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Sign Up',
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
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Sign up to get started',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 60.h),

                // Name Input Field
                CustomTextEditingWidget(
                  label: 'Name',
                  controller: controller.nameController.value,
                  hint: 'Enter your name',
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(Icons.person_outlined),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 12.w,
                  ),
                  validator: controller.validateName,
                ),

                SizedBox(height: 16.h),

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

                SizedBox(height: 16.h),

                // Confirm Password Input Field
                CustomTextEditingWidget(
                  label: 'Confirm Password',
                  controller: controller.confirmPasswordController.value,
                  hint: 'Confirm your password',
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 12.w,
                  ),
                  validator: controller.validateConfirmPassword,
                ),

                SizedBox(height: 24.h),

                // Sign Up Button
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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

                SizedBox(height: 40.h),

                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        'Sign In',
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
