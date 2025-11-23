import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/scanner/controllers/scanner_controller.dart';
import 'package:safe_drive/features/scanner/screen/components/scanner_camera_preview_component.dart';
import 'package:safe_drive/features/scanner/screen/components/scanner_control_buttons_component.dart';
import 'package:safe_drive/features/scanner/screen/components/scanner_detection_status_component.dart';
import 'package:safe_drive/features/scanner/screen/components/scanner_statistics_component.dart';
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
        title: 'Drowsiness Detection',
        actions: [
          Obx(() {
            return Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: controller.isScanning.value
                    ? ColorStyle.success.withOpacity(0.1)
                    : ColorStyle.backgroundGray,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: controller.isScanning.value ? ColorStyle.success : ColorStyle.border,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: controller.isScanning.value ? ColorStyle.success : ColorStyle.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    controller.isScanning.value ? 'Active' : 'Inactive',
                    style: TextStyles.labelSmall.copyWith(
                      color: controller.isScanning.value ? ColorStyle.success : ColorStyle.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
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
                style: TextStyles.bodyMedium.copyWith(color: ColorStyle.textSecondary),
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
              _buildSafetyTips(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build safety tips section
  Widget _buildSafetyTips() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorStyle.info.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorStyle.info.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 20.sp, color: ColorStyle.info),
              SizedBox(width: 8.w),
              Text('Safety Tips', style: TextStyles.titleSmall.copyWith(color: ColorStyle.info)),
            ],
          ),
          SizedBox(height: 12.h),
          _buildTipItem('Take regular breaks every 2 hours'),
          SizedBox(height: 8.h),
          _buildTipItem('Pull over safely if you feel drowsy'),
          SizedBox(height: 8.h),
          _buildTipItem('Get adequate sleep before long drives'),
          SizedBox(height: 8.h),
          _buildTipItem('Avoid driving during your usual sleep time'),
        ],
      ),
    );
  }

  /// Build individual tip item
  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h),
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(color: ColorStyle.info, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(text, style: TextStyles.bodySmall.copyWith(color: ColorStyle.textSecondary)),
        ),
      ],
    );
  }
}
