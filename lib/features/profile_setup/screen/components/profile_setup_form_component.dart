import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/profile_setup/controllers/profile_setup_controller.dart';
import 'package:safe_drive/shared/widgets/custom_text_form_field_widget.dart';

class ProfileSetupFormComponent extends GetView<ProfileSetupController> {
  const ProfileSetupFormComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormFieldWidget(
      label: 'Full Name',
      controller: controller.nameController.value,
      hint: 'Enter your full name',
      keyboardType: TextInputType.name,
      prefixIcon: const Icon(Icons.person_outlined),
      validator: controller.validateName,
    );
  }
}
