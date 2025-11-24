import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/setting/controllers/setting_controller.dart';
import 'package:safe_drive/features/setting/screen/components/setting_header_component.dart';
import 'package:safe_drive/features/setting/screen/components/setting_list_component.dart';
import 'package:safe_drive/shared/styles/color_style.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.backgroundGray,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user profile
              const SettingHeaderComponent(),

              // Settings list
              const SettingListComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
