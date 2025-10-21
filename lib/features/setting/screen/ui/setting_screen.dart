import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:safe_drive/features/setting/controllers/setting_controller.dart';
import 'package:safe_drive/shared/widgets/custom_app_bar_widget.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: ("Setting"),
      ),
      body: Center(),
    );
  }
}
