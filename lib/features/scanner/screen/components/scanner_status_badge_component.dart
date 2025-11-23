import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/scanner/controllers/scanner_controller.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

/// Status badge component showing active/inactive state
class ScannerStatusBadgeComponent extends GetView<ScannerController> {
  const ScannerStatusBadgeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: controller.isScanning.value
              ? ColorStyle.success.withValues(alpha: 0.1)
              : ColorStyle.backgroundGray,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: controller.isScanning.value
                ? ColorStyle.success
                : ColorStyle.border,
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
                color: controller.isScanning.value
                    ? ColorStyle.success
                    : ColorStyle.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              controller.isScanning.value ? 'Active' : 'Inactive',
              style: TextStyles.labelSmall.copyWith(
                color: controller.isScanning.value
                    ? ColorStyle.success
                    : ColorStyle.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    });
  }
}
