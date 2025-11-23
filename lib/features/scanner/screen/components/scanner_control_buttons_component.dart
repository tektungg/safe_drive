import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/scanner/controllers/scanner_controller.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

/// Control buttons component for scanner
///
/// Contains start/stop scanning button and additional controls
class ScannerControlButtonsComponent extends GetView<ScannerController> {
  const ScannerControlButtonsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          // Main scan button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: controller.isCameraInitializing.value
                  ? null
                  : () {
                      if (controller.isScanning.value) {
                        controller.stopScanning();
                      } else {
                        controller.startScanning();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.isScanning.value ? ColorStyle.danger : ColorStyle.primary,
                foregroundColor: ColorStyle.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    controller.isScanning.value ? Icons.stop_circle_outlined : Icons.play_circle_outline,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    controller.isScanning.value ? 'Stop Detection' : 'Start Detection',
                    style: TextStyles.buttonMedium,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Settings button
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorStyle.border, width: 1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Open settings
              },
              icon: Icon(Icons.settings_outlined, size: 24.sp, color: ColorStyle.textPrimary),
              tooltip: 'Settings',
            ),
          ),

          SizedBox(width: 12.w),

          // Info button
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorStyle.border, width: 1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              onPressed: () {
                _showInfoDialog(context);
              },
              icon: Icon(Icons.info_outline, size: 24.sp, color: ColorStyle.textPrimary),
              tooltip: 'Information',
            ),
          ),
        ],
      );
    });
  }

  /// Show information dialog
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: ColorStyle.primary, size: 24.sp),
            SizedBox(width: 12.w),
            Text('How It Works', style: TextStyles.titleLarge),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoItem(
                icon: Icons.camera_alt_outlined,
                title: 'Face Detection',
                description:
                    'The app uses your front camera to detect your face and monitor drowsiness indicators.',
              ),
              SizedBox(height: 16.h),
              _buildInfoItem(
                icon: Icons.remove_red_eye_outlined,
                title: 'Eye Monitoring',
                description:
                    'Tracks how long your eyes are closed. Extended closure increases drowsiness score.',
              ),
              SizedBox(height: 16.h),
              _buildInfoItem(
                icon: Icons.mood_bad_outlined,
                title: 'Yawn Detection',
                description: 'Detects yawning, a common sign of fatigue and drowsiness.',
              ),
              SizedBox(height: 16.h),
              _buildInfoItem(
                icon: Icons.warning_amber_outlined,
                title: 'Alert Levels',
                description: 'Safe (0-25%), Moderate (25-50%), Risky (50-75%), Dangerous (75-100%)',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got It', style: TextStyles.buttonMedium.copyWith(color: ColorStyle.primary)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      ),
    );
  }

  /// Build info item
  Widget _buildInfoItem({required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: ColorStyle.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 20.sp, color: ColorStyle.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 4.h),
              Text(description, style: TextStyles.bodySmall.copyWith(color: ColorStyle.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
