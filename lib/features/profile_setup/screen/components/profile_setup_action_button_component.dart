import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/profile_setup/controllers/profile_setup_controller.dart';
import 'package:safe_drive/shared/widgets/custom_button_widget.dart';

class ProfileSetupActionButtonComponent extends GetView<ProfileSetupController> {
  const ProfileSetupActionButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomButtonWidget(
          text: 'Save Profile',
          onPressed: controller.saveProfile,
          isLoading: controller.isLoading.value,
          backgroundColor: const Color(0xFF3B82F6),
          textColor: Colors.white,
        ));
  }
}
