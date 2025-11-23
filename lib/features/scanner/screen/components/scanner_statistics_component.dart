import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/scanner/controllers/scanner_controller.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

/// Statistics component showing detection counts
///
/// Displays eye closed count, yawn count, and session duration
class ScannerStatisticsComponent extends GetView<ScannerController> {
  const ScannerStatisticsComponent({super.key});

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
            Text('Session Statistics', style: TextStyles.titleMedium),

            SizedBox(height: 16.h),

            // Statistics grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.remove_red_eye_outlined,
                    label: 'Eyes Closed',
                    value: controller.eyeClosedCount.value.toString(),
                    color: ColorStyle.warning,
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: _buildStatCard(
                    icon: Icons.mood_bad_outlined,
                    label: 'Yawns',
                    value: controller.yawnCount.value.toString(),
                    color: ColorStyle.info,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Duration card
            _buildStatCard(
              icon: Icons.timer_outlined,
              label: 'Session Duration',
              value: _formatDuration(controller.sessionDuration.value),
              color: ColorStyle.primary,
              isFullWidth: true,
            ),
          ],
        ),
      );
    });
  }

  /// Build individual stat card
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: isFullWidth
          ? Row(
              children: [
                Icon(icon, size: 24.sp, color: color),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyles.labelMedium.copyWith(
                          color: ColorStyle.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        value,
                        style: TextStyles.titleLarge.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 24.sp, color: color),
                SizedBox(height: 12.h),
                Text(
                  label,
                  style: TextStyles.labelMedium.copyWith(
                    color: ColorStyle.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyles.titleLarge.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }

  /// Format duration in seconds to readable string
  String _formatDuration(double seconds) {
    if (seconds < 60) {
      return '${seconds.toInt()}s';
    } else if (seconds < 3600) {
      final minutes = (seconds / 60).floor();
      final remainingSeconds = (seconds % 60).floor();
      return '${minutes}m ${remainingSeconds}s';
    } else {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).floor();
      return '${hours}h ${minutes}m';
    }
  }
}
