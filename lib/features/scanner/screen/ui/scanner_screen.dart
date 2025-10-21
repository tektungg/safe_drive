import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/scanner/controllers/scanner_controller.dart';

class ScannerScreen extends GetView<ScannerController> {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Scanner"),
      ),
      body: const Center(),
    );
  }
}
