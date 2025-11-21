import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/features/sign_in/controllers/sign_in_controller.dart';
import 'package:safe_drive/features/sign_in/screen/components/sign_in_action_button_component.dart';
import 'package:safe_drive/features/sign_in/screen/components/sign_in_form_component.dart';
import 'package:safe_drive/shared/widgets/auth_footer_widget.dart';
import 'package:safe_drive/shared/widgets/auth_header_widget.dart';
import 'package:safe_drive/shared/widgets/custom_app_bar_widget.dart';

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
                const AuthHeaderWidget(
                  title: 'Welcome Back',
                  subtitle: 'Sign in to continue',
                ),
                const SignInFormComponent(),
                const SignInActionButtonComponent(),
                AuthFooterWidget(
                  text: "Don't have an account? ",
                  actionText: 'Sign Up',
                  onActionTap: () => Get.toNamed(Routes.signUpRoute),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
