import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/sign_in/controllers/sign_in_controller.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';
import 'package:safe_drive/shared/widgets/custom_text_form_field_widget.dart';
import 'package:safe_drive/shared/widgets/custom_toast_widget.dart';
import 'package:safe_drive/shared/widgets/password_requirements_widget.dart';

class SignInFormComponent extends GetView<SignInController> {
  const SignInFormComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email Input Field
        CustomTextFormFieldWidget(
          label: 'Email',
          controller: controller.emailController.value,
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: controller.validateEmail,
        ),

        SizedBox(height: 16.h),

        // Password Input Field
        Focus(
          onFocusChange: (hasFocus) {
            controller.isPasswordFocused.value = hasFocus;
          },
          child: CustomTextFormFieldWidget(
            label: 'Password',
            controller: controller.passwordController.value,
            hint: 'Enter your password',
            isPassword: true,
            prefixIcon: const Icon(Icons.lock_outlined),
            validator: controller.validatePassword,
          ),
        ),

        // Password Requirements
        Obx(
          () => PasswordRequirementsWidget(
            isVisible: controller.isPasswordFocused.value,
            shouldShake: controller.shakePasswordRequirements.value,
            hasMinLength: controller.hasMinLength.value,
            hasLowercase: controller.hasLowercase.value,
            hasUppercase: controller.hasUppercase.value,
            hasNumber: controller.hasNumber.value,
            hasSymbol: controller.hasSymbol.value,
          ),
        ),

        SizedBox(height: 16.h),

        // Forgot Password & Remember Me Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Remember Me Checkbox
            Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) =>
                          controller.toggleRememberMe(value ?? false),
                      activeColor: ColorStyle.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Remember me',
                    style: TextStyles.bodySmall.copyWith(
                      color: ColorStyle.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Forgot Password Link
            TextButton(
              onPressed: () {
                // TODO: Navigate to forgot password screen
                // Get.toNamed(Routes.forgotPasswordRoute);
                CustomToast.show(
                  message: 'Forgot password feature will be available soon',
                  type: ToastType.info,
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password?',
                style: TextStyles.linkPlain.copyWith(fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
