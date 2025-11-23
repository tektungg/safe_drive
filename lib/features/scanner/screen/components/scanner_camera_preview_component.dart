import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/scanner/controllers/scanner_controller.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';
import 'package:safe_drive/shared/widgets/custom_shimmer_widget.dart';

/// Camera preview component for scanner screen
///
/// Displays camera preview in a rounded container with 4:3 aspect ratio
/// Shows loading state while camera is initializing
class ScannerCameraPreviewComponent extends GetView<ScannerController> {
  const ScannerCameraPreviewComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCameraInitializing.value) {
        return _buildLoadingState();
      }

      if (controller.cameraController.value == null ||
          !controller.cameraController.value!.value.isInitialized) {
        return _buildErrorState();
      }

      return _buildCameraPreview();
    });
  }

  /// Build camera preview with rounded container
  Widget _buildCameraPreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorStyle.black,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(color: ColorStyle.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: AspectRatio(aspectRatio: 4 / 3, child: CameraPreview(controller.cameraController.value!)),
      ),
    );
  }

  /// Build loading state with shimmer
  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: ColorStyle.surface, borderRadius: BorderRadius.circular(24.r)),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomShimmerWidget(width: double.infinity, height: double.infinity, borderRadius: 24.r),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: ColorStyle.primary),
                SizedBox(height: 16.h),
                Text(
                  'Initializing camera...',
                  style: TextStyles.bodyMedium.copyWith(color: ColorStyle.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorStyle.dangerContainer,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ColorStyle.danger.withOpacity(0.3), width: 2),
      ),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 64.sp, color: ColorStyle.danger),
            SizedBox(height: 16.h),
            Text('Camera not available', style: TextStyles.titleMedium.copyWith(color: ColorStyle.danger)),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                'Please check camera permissions',
                style: TextStyles.bodySmall.copyWith(color: ColorStyle.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
