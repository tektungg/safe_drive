import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/scanner/controllers/scanner_controller.dart';
import 'package:safe_drive/features/scanner/screen/components/scanner_camera_preview_component.dart';
import 'package:safe_drive/features/scanner/screen/components/scanner_control_buttons_component.dart';
import 'package:safe_drive/features/scanner/screen/components/scanner_detection_status_component.dart';
import 'package:safe_drive/features/scanner/screen/components/scanner_safety_tips_component.dart';
import 'package:safe_drive/features/scanner/screen/components/scanner_statistics_component.dart';
import 'package:safe_drive/features/scanner/screen/components/scanner_status_badge_component.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';
import 'package:safe_drive/shared/widgets/custom_app_bar_widget.dart';

/// Scanner screen for drowsiness detection
///
/// Displays camera preview, detection status, statistics, and controls
class ScannerScreen extends GetView<ScannerController> {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.scaffold,
      appBar: CustomAppBarWidget(
        title: 'Detection',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: const ScannerStatusBadgeComponent(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header text
              Text('Driver Monitoring', style: TextStyles.headlineMedium),
              SizedBox(height: 8.h),
              Text(
                'Position your face in the camera frame to start monitoring',
                style: TextStyles.bodyMedium.copyWith(
                  color: ColorStyle.textSecondary,
                ),
              ),

              SizedBox(height: 24.h),

              // Camera preview (4:3 aspect ratio, rounded container)
              const ScannerCameraPreviewComponent(),

              SizedBox(height: 24.h),

              // Detection status
              const ScannerDetectionStatusComponent(),

              SizedBox(height: 16.h),

              // Statistics
              const ScannerStatisticsComponent(),

              SizedBox(height: 24.h),

              // Control buttons
              const ScannerControlButtonsComponent(),

              SizedBox(height: 16.h),

              // Safety tips
              const ScannerSafetyTipsComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
