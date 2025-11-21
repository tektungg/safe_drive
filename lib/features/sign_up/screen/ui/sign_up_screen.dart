import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/sign_up/controllers/sign_up_controller.dart';
import 'package:safe_drive/features/sign_up/screen/components/sign_up_action_button_component.dart';
import 'package:safe_drive/features/sign_up/screen/components/sign_up_form_component.dart';
import 'package:safe_drive/shared/widgets/auth_footer_widget.dart';
import 'package:safe_drive/shared/widgets/auth_header_widget.dart';
import 'package:safe_drive/shared/widgets/custom_app_bar_widget.dart';

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
                const AuthHeaderWidget(
                  title: 'Create Account',
                  subtitle: 'Sign up to get started',
                ),
                const SignUpFormComponent(),
                const SignUpActionButtonComponent(),
                AuthFooterWidget(
                  text: 'Already have an account? ',
                  actionText: 'Sign In',
                  onActionTap: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
