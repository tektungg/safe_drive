import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

/// Safety tips component with helpful information
class ScannerSafetyTipsComponent extends StatelessWidget {
  const ScannerSafetyTipsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorStyle.infoContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorStyle.info.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20.sp,
                color: ColorStyle.info,
              ),
              SizedBox(width: 8.w),
              Text(
                'Safety Tips',
                style: TextStyles.titleMedium.copyWith(
                  color: ColorStyle.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Tips list
          _buildTip(
            'Position your face clearly in the camera frame',
            Icons.face_outlined,
          ),
          SizedBox(height: 8.h),
          _buildTip(
            'Ensure good lighting for accurate detection',
            Icons.wb_sunny_outlined,
          ),
          SizedBox(height: 8.h),
          _buildTip(
            'Take breaks every 2 hours during long drives',
            Icons.schedule_outlined,
          ),
          SizedBox(height: 8.h),
          _buildTip(
            'Pull over safely if you feel drowsy',
            Icons.local_parking_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: ColorStyle.info,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyles.bodySmall.copyWith(
              color: ColorStyle.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
