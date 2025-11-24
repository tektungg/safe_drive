import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/setting/controllers/setting_controller.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

/// Header component for the Settings screen
///
/// Displays user profile information including avatar, name, and email
class SettingHeaderComponent extends GetView<SettingController> {
  const SettingHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorStyle.primary, ColorStyle.primaryDark],
        ),
      ),
      child: Column(
        children: [
          // Profile Avatar
          SizedBox(height: 16.h),
          Obx(
            () => Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorStyle.white, width: 1.w),
                boxShadow: [
                  BoxShadow(
                    color: ColorStyle.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: ColorStyle.white,
                backgroundImage: controller.userAvatar.value.isNotEmpty
                    ? NetworkImage(controller.userAvatar.value)
                    : null,
                child: controller.userAvatar.value.isEmpty
                    ? Icon(Icons.person, size: 40.sp, color: ColorStyle.primary)
                    : null,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // User Name
          Obx(
            () => Text(
              controller.userName.value,
              style: TextStyles.headlineMedium.copyWith(
                color: ColorStyle.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 4.h),

          // User Email
          Obx(
            () => Text(
              controller.userEmail.value,
              style: TextStyles.bodyMedium.copyWith(
                color: ColorStyle.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 16.h),

          // Edit Profile Button
          InkWell(
            onTap: () => controller.navigateToEditProfile(),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: ColorStyle.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: ColorStyle.white.withValues(alpha: 0.3),
                  width: 1.w,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 16.sp,
                    color: ColorStyle.white,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Edit Profile',
                    style: TextStyles.labelMedium.copyWith(
                      color: ColorStyle.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
