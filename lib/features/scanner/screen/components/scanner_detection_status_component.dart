import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/scanner/controllers/scanner_controller.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

/// Detection status component showing current detection state
///
/// Displays status message and drowsiness score with animated progress indicator
class ScannerDetectionStatusComponent extends GetView<ScannerController> {
  const ScannerDetectionStatusComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ColorStyle.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorStyle.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status header
            Row(
              children: [
                Icon(
                  Icons.radar,
                  size: 24.sp,
                  color: controller.isScanning.value ? ColorStyle.primary : ColorStyle.textSecondary,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.detectionStatus.value, style: TextStyles.titleMedium),
                      SizedBox(height: 4.h),
                      Text(
                        controller.detectionStatusMessage.value,
                        style: TextStyles.bodySmall.copyWith(color: ColorStyle.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Drowsiness score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Drowsiness Score',
                  style: TextStyles.labelLarge.copyWith(color: ColorStyle.textSecondary),
                ),
                Text(
                  '${controller.drowsinessScore.value}%',
                  style: TextStyles.titleLarge.copyWith(
                    color: controller.getAlertLevelColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                value: controller.drowsinessScore.value / 100,
                backgroundColor: ColorStyle.backgroundGray,
                valueColor: AlwaysStoppedAnimation<Color>(controller.getAlertLevelColor()),
                minHeight: 8.h,
              ),
            ),

            SizedBox(height: 12.h),

            // Alert level badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: controller.getAlertLevelColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: controller.getAlertLevelColor().withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getAlertIcon(), size: 16.sp, color: controller.getAlertLevelColor()),
                  SizedBox(width: 6.w),
                  Text(
                    controller.getAlertLevelText(),
                    style: TextStyles.labelMedium.copyWith(
                      color: controller.getAlertLevelColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Get icon based on alert level
  IconData _getAlertIcon() {
    switch (controller.alertLevel.value) {
      case 'safe':
        return Icons.check_circle_outline;
      case 'moderate':
        return Icons.warning_amber_outlined;
      case 'risky':
        return Icons.error_outline;
      case 'dangerous':
        return Icons.dangerous_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }
}
