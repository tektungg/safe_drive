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
      return Container(
        decoration: BoxDecoration(
          color: ColorStyle.white,
          boxShadow: [
            BoxShadow(
              color: ColorStyle.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
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
                    backgroundColor: controller.isScanning.value
                        ? ColorStyle.danger
                        : ColorStyle.primary,
                    foregroundColor: ColorStyle.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.isScanning.value
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        controller.isScanning.value
                            ? 'Stop Detection'
                            : 'Start Detection',
                        style: TextStyles.buttonMedium,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // Settings button
              SizedBox(
                height: 56.h,
                width: 56.w,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorStyle.border, width: 1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // TODO: Open settings
                    },
                    icon: Icon(
                      Icons.settings_outlined,
                      size: 24.sp,
                      color: ColorStyle.textPrimary,
                    ),
                    tooltip: 'Settings',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
