import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/edit_profile/controllers/edit_profile_controller.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("EditProfile"),
      ),
      body: const Center(),
    );
  }
}
    