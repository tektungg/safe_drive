import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/sign_in/controllers/sign_in_controller.dart';
import 'package:safe_drive/shared/widgets/custom_text_editing_widget.dart';
import 'package:safe_drive/shared/widgets/password_requirements_widget.dart';

class SignInFormComponent extends GetView<SignInController> {
  const SignInFormComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}
