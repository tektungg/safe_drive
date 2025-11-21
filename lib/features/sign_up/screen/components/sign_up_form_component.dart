import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/sign_up/controllers/sign_up_controller.dart';
import 'package:safe_drive/shared/widgets/custom_text_editing_widget.dart';
import 'package:safe_drive/shared/widgets/password_requirements_widget.dart';

class SignUpFormComponent extends GetView<SignUpController> {
  const SignUpFormComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Focus(
          onFocusChange: (hasFocus) {
            controller.isPasswordFocused.value = hasFocus;
          },
          child: CustomTextEditingWidget(
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
        ),

        // Password Requirements
        Obx(() => PasswordRequirementsWidget(
              isVisible: controller.isPasswordFocused.value,
              shouldShake: controller.shakePasswordRequirements.value,
              hasMinLength: controller.hasMinLength.value,
              hasLowercase: controller.hasLowercase.value,
              hasUppercase: controller.hasUppercase.value,
              hasNumber: controller.hasNumber.value,
              hasSymbol: controller.hasSymbol.value,
            )),

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
      ],
    );
  }
}
