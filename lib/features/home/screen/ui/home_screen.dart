import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/home/controllers/home_controller.dart';
import 'package:safe_drive/shared/widgets/custom_app_bar_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        centerTitle: true,
        title: 'Home',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.signOut,
          ),
        ],
      ),
      body: const Center(),
    );
  }
}
