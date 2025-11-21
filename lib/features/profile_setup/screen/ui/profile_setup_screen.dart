import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/profile_setup/controllers/profile_setup_controller.dart';
import 'package:safe_drive/features/profile_setup/screen/components/profile_setup_action_button_component.dart';
import 'package:safe_drive/features/profile_setup/screen/components/profile_setup_avatar_component.dart';
import 'package:safe_drive/features/profile_setup/screen/components/profile_setup_form_component.dart';
import 'package:safe_drive/features/profile_setup/screen/components/profile_setup_header_component.dart';

class ProfileSetupScreen extends GetView<ProfileSetupController> {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: controller.formKey.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const ProfileSetupHeaderComponent(),

                SizedBox(height: 40.h),

                // Profile Photo
                const ProfileSetupAvatarComponent(),

                SizedBox(height: 40.h),

                // Name Input Field
                const ProfileSetupFormComponent(),

                SizedBox(height: 40.h),

                // Save Button
                const ProfileSetupActionButtonComponent(),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
