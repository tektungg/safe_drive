import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/home/controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
      ),
      body: const Center(),
    );
  }
}
